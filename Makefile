# home-infra/Makefile

up:
	@echo "🚀 Starting all stacks..."
	@find docker -name "docker-compose.yml" -execdir docker compose up -d \;

down:
	@echo "🧹 Stopping all stacks..."
	@find docker -name "docker-compose.yml" -execdir docker compose down \;

pull:
	@echo "📦 Updating images..."
	@find docker -name "docker-compose.yml" -execdir docker compose pull \;

ps:
	@docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"

logs:
	@docker logs -f dozzle || true
