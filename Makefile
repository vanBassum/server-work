# Makefile in /opt/server-config

# Start all stacks
up:
	@echo "🚀 Starting all stacks..."
	@find docker -maxdepth 2 -name "docker-compose.yml" -execdir docker compose up -d \;

# Stop all stacks
down:
	@echo "🧹 Stopping all stacks..."
	@find docker -maxdepth 2 -name "docker-compose.yml" -execdir docker compose down \;

# Pull latest images
pull:
	@echo "📦 Updating images..."
	@find docker -maxdepth 2 -name "docker-compose.yml" -execdir docker compose pull \;

# Show running containers
ps:
	@docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"

# Tail logs for one service (e.g. make logs stack=dozzle)
logs:
	@docker compose -f docker/$(stack)/docker-compose.yml logs -f
