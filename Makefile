SHELL := /bin/bash

# Ensure shared networks exist
setup:
	@echo "Creating shared networks if they don't exist..."
	@if ! docker network inspect ingress-network >/dev/null 2>&1; then \
		echo "Creating ingress-network..."; \
		docker network create ingress-network; \
	else \
		echo "ingress-network already exists."; \
	fi
	@echo "Networks ready."

# Start all or one stack
up:
	@if [ -n "$(stack)" ]; then \
		echo "Starting stack: $(stack)..."; \
		file=$$(find $(CURDIR)/stacks/$(stack) -maxdepth 1 -type f -name "$(stack)-compose.yml"); \
		if [ -n "$$file" ]; then \
			docker compose --env-file $(CURDIR)/.env -f "$$file" up -d; \
		else \
			echo "Compose file for $(stack) not found."; \
		fi; \
	else \
		echo "Starting all stacks..."; \
		find $(CURDIR)/stacks -maxdepth 2 -type f -name "*-compose.yml" \
			-execdir docker compose --env-file $(CURDIR)/.env -f {} up -d \; ; \
	fi

down:
	@if [ -n "$(stack)" ]; then \
		echo "Stopping stack: $(stack)..."; \
		file=$$(find $(CURDIR)/stacks/$(stack) -maxdepth 1 -type f -name "$(stack)-compose.yml"); \
		if [ -n "$$file" ]; then \
			docker compose --env-file $(CURDIR)/.env -f "$$file" down; \
		else \
			echo "Compose file for $(stack) not found."; \
		fi; \
	else \
		echo "Stopping all stacks..."; \
		find $(CURDIR)/stacks -maxdepth 2 -type f -name "*-compose.yml" \
			-execdir docker compose --env-file $(CURDIR)/.env -f {} down \; ; \
	fi

pull:
	@echo "Updating all images..."
	@find $(CURDIR)/stacks -maxdepth 2 -type f -name "*-compose.yml" \
		-execdir docker compose --env-file $(CURDIR)/.env -f {} pull \;


ps:
	@docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"
