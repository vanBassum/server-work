SHELL := /bin/bash

# Start all or one stack
up:
	@if [ -n "$(stack)" ]; then \
		echo "Starting stack: $(stack)..."; \
		file=$$(find $(CURDIR)/docker/$(stack) -maxdepth 1 -type f -name "$(stack)-compose.yml"); \
		if [ -n "$$file" ]; then docker compose -f "$$file" up -d; else echo "❌ Compose file for $(stack) not found."; fi; \
	else \
		echo "Starting all stacks..."; \
		find $(CURDIR)/docker -maxdepth 2 -type f -name "*-compose.yml" -execdir docker compose -f {} up -d \; ; \
	fi

down:
	@if [ -n "$(stack)" ]; then \
		echo "Stopping stack: $(stack)..."; \
		file=$$(find $(CURDIR)/docker/$(stack) -maxdepth 1 -type f -name "$(stack)-compose.yml"); \
		if [ -n "$$file" ]; then docker compose -f "$$file" down; else echo "❌ Compose file for $(stack) not found."; fi; \
	else \
		echo "Stopping all stacks..."; \
		find $(CURDIR)/docker -maxdepth 2 -type f -name "*-compose.yml" -execdir docker compose -f {} down \; ; \
	fi

pull:
	@echo "Updating all images..."
	@find $(CURDIR)/docker -maxdepth 2 -type f -name "*-compose.yml" -execdir docker compose -f {} pull \;

ps:
	@docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"
