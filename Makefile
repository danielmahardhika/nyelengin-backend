# ─────────────────────────────────────────────────────────
#  Nyelengin Backend — Makefile
#  Microservices: user-service (C# .NET) & ledger-service (Java Spring Boot)
# ─────────────────────────────────────────────────────────

.PHONY: help docker-up docker-down docker-restart docker-logs \
        run-user build-user clean-user \
        run-ledger build-ledger clean-ledger \
        db-migrate db-seed db-reset \
        run-all build-all clean-all

.DEFAULT_GOAL := help

# ── Colors ──────────────────────────────────────────────
CYAN  := \033[36m
GREEN := \033[32m
RESET := \033[0m

# ═══════════════════════════════════════════════════════
#  Docker (PostgreSQL)
# ═══════════════════════════════════════════════════════

docker-up: ## Start PostgreSQL container
	docker compose up -d

docker-down: ## Stop PostgreSQL container
	docker compose down

docker-restart: ## Restart PostgreSQL container
	docker compose down && docker compose up -d

docker-logs: ## Tail PostgreSQL container logs
	docker compose logs -f db

# ═══════════════════════════════════════════════════════
#  C# .NET — User Service (port 5219)
# ═══════════════════════════════════════════════════════

run-user: ## Run user-service (dotnet run)
	cd user-service && dotnet run

build-user: ## Build user-service
	cd user-service && dotnet build

clean-user: ## Clean user-service build artifacts
	cd user-service && dotnet clean

# ═══════════════════════════════════════════════════════
#  Java Spring Boot — Ledger Service (port 8080)
# ═══════════════════════════════════════════════════════

run-ledger: ## Run ledger-service (Spring Boot)
	cd ledger-service && ./mvnw spring-boot:run

build-ledger: ## Build ledger-service
	cd ledger-service && ./mvnw clean package -DskipTests

clean-ledger: ## Clean ledger-service build artifacts
	cd ledger-service && ./mvnw clean

# ═══════════════════════════════════════════════════════
#  Prisma (Database Schema & Seeding)
# ═══════════════════════════════════════════════════════

db-migrate: ## Run Prisma migrations
	npx prisma migrate deploy

db-seed: ## Seed the database via Prisma
	npx prisma db seed

db-reset: ## Reset database (drop, migrate, seed)
	npx prisma migrate reset

db-studio: ## Open Prisma Studio (GUI)
	npx prisma studio

# ═══════════════════════════════════════════════════════
#  Combo Targets
# ═══════════════════════════════════════════════════════

build-all: build-user build-ledger ## Build all services

clean-all: clean-user clean-ledger ## Clean all build artifacts

setup: docker-up ## First-time setup: start DB, install deps, migrate, seed
	@echo "$(CYAN)Installing Node dependencies...$(RESET)"
	npm install
	@echo "$(CYAN)Running Prisma migrations...$(RESET)"
	npx prisma migrate deploy
	@echo "$(CYAN)Seeding database...$(RESET)"
	npx prisma db seed
	@echo "$(CYAN)Building user-service...$(RESET)"
	cd user-service && dotnet build
	@echo "$(CYAN)Building ledger-service...$(RESET)"
	cd ledger-service && ./mvnw clean package -DskipTests -q
	@echo "$(GREEN)✅ Setup complete!$(RESET)"

# ═══════════════════════════════════════════════════════
#  Help
# ═══════════════════════════════════════════════════════

help: ## Show this help message
	@echo ""
	@echo "$(GREEN)Nyelengin Backend — Available Commands$(RESET)"
	@echo "────────────────────────────────────────"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  $(CYAN)make %-15s$(RESET) %s\n", $$1, $$2}'
	@echo ""
