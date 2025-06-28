# GEMVC Framework Makefile
.PHONY: help install update test clean docker-up docker-down analyze fix-style coverage docs

# Default target
.DEFAULT_GOAL := help

# Variables
DOCKER_COMPOSE = docker-compose
PHP = php
COMPOSER = composer
PHPUNIT = vendor/bin/phpunit
PHPSTAN = vendor/bin/phpstan
PSALM = vendor/bin/psalm
PHP_CS_FIXER = vendor/bin/php-cs-fixer

# Colors
GREEN = \033[0;32m
YELLOW = \033[0;33m
RED = \033[0;31m
NC = \033[0m # No Color

## Help
help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  ${GREEN}%-20s${NC} %s\n", $$1, $$2}' $(MAKEFILE_LIST)

## Installation
install: ## Install dependencies
	@echo "${YELLOW}Installing dependencies...${NC}"
	$(COMPOSER) install
	@echo "${GREEN}✓ Dependencies installed${NC}"

update: ## Update dependencies
	@echo "${YELLOW}Updating dependencies...${NC}"
	$(COMPOSER) update
	@echo "${GREEN}✓ Dependencies updated${NC}"

## Testing
test: ## Run all tests
	@echo "${YELLOW}Running tests...${NC}"
	$(PHPUNIT)
	@echo "${GREEN}✓ All tests passed${NC}"

test-unit: ## Run unit tests
	@echo "${YELLOW}Running unit tests...${NC}"
	$(PHPUNIT) --testsuite=unit

test-integration: ## Run integration tests
	@echo "${YELLOW}Running integration tests...${NC}"
	$(PHPUNIT) --testsuite=integration

test-coverage: ## Run tests with coverage
	@echo "${YELLOW}Running tests with coverage...${NC}"
	$(PHPUNIT) --coverage-html coverage
	@echo "${GREEN}✓ Coverage report generated in coverage/${NC}"

## Code Quality
analyze: ## Run static analysis
	@echo "${YELLOW}Running PHPStan...${NC}"
	$(PHPSTAN) analyse
	@echo "${YELLOW}Running Psalm...${NC}"
	$(PSALM)
	@echo "${GREEN}✓ Static analysis complete${NC}"

cs-check: ## Check code style
	@echo "${YELLOW}Checking code style...${NC}"
	$(PHP_CS_FIXER) fix --dry-run --diff

cs-fix: ## Fix code style
	@echo "${YELLOW}Fixing code style...${NC}"
	$(PHP_CS_FIXER) fix
	@echo "${GREEN}✓ Code style fixed${NC}"

lint: ## Run all linters
	@make cs-check
	@make analyze

## Docker
docker-up: ## Start Docker containers
	@echo "${YELLOW}Starting Docker containers...${NC}"
	$(DOCKER_COMPOSE) up -d
	@echo "${GREEN}✓ Containers started${NC}"
	@echo ""
	@echo "Services available at:"
	@echo "  - Application: http://localhost:9501"
	@echo "  - PHPMyAdmin: http://localhost:8080"
	@echo "  - Redis Commander: http://localhost:8081"
	@echo "  - MailHog: http://localhost:8025"
	@echo "  - Prometheus: http://localhost:9090"
	@echo "  - Grafana: http://localhost:3000"
	@echo "  - SonarQube: http://localhost:9000"

docker-down: ## Stop Docker containers
	@echo "${YELLOW}Stopping Docker containers...${NC}"
	$(DOCKER_COMPOSE) down
	@echo "${GREEN}✓ Containers stopped${NC}"

docker-logs: ## View Docker logs
	$(DOCKER_COMPOSE) logs -f

docker-shell: ## Enter app container shell
	$(DOCKER_COMPOSE) exec app sh

docker-rebuild: ## Rebuild Docker containers
	@echo "${YELLOW}Rebuilding Docker containers...${NC}"
	$(DOCKER_COMPOSE) down
	$(DOCKER_COMPOSE) build --no-cache
	$(DOCKER_COMPOSE) up -d
	@echo "${GREEN}✓ Containers rebuilt${NC}"

## Database
db-migrate: ## Run database migrations
	@echo "${YELLOW}Running migrations...${NC}"
	$(PHP) bin/gemvc migrate
	@echo "${GREEN}✓ Migrations complete${NC}"

db-rollback: ## Rollback database migrations
	@echo "${YELLOW}Rolling back migrations...${NC}"
	$(PHP) bin/gemvc migrate:rollback
	@echo "${GREEN}✓ Rollback complete${NC}"

db-seed: ## Seed the database
	@echo "${YELLOW}Seeding database...${NC}"
	$(PHP) bin/gemvc db:seed
	@echo "${GREEN}✓ Database seeded${NC}"

db-fresh: ## Fresh database with seeds
	@echo "${YELLOW}Refreshing database...${NC}"
	$(PHP) bin/gemvc migrate:fresh --seed
	@echo "${GREEN}✓ Database refreshed${NC}"

## Documentation
docs-generate: ## Generate API documentation
	@echo "${YELLOW}Generating documentation...${NC}"
	$(PHP) bin/gemvc docs:generate
	@echo "${GREEN}✓ Documentation generated${NC}"

docs-serve: ## Serve documentation locally
	@echo "${YELLOW}Starting documentation server...${NC}"
	php -S localhost:8888 -t docs/

## Development
dev-setup: ## Setup development environment
	@make install
	@make docker-up
	@make db-migrate
	@make db-seed
	@echo "${GREEN}✓ Development environment ready${NC}"

clean: ## Clean generated files
	@echo "${YELLOW}Cleaning generated files...${NC}"
	rm -rf vendor/
	rm -rf coverage/
	rm -rf .phpunit.cache/
	rm -rf .psalm-cache/
	@echo "${GREEN}✓ Clean complete${NC}"

## Releases
changelog: ## Generate changelog
	@echo "${YELLOW}Generating changelog...${NC}"
	conventional-changelog -p angular -i CHANGELOG.md -s
	@echo "${GREEN}✓ Changelog generated${NC}"

release: ## Create a new release
	@echo "${YELLOW}Creating release...${NC}"
	@read -p "Version number (e.g., 1.0.0): " version; \
	git tag -a v$$version -m "Release v$$version"; \
	git push origin v$$version
	@echo "${GREEN}✓ Release created${NC}"

## CI/CD
ci-test: ## Run CI test suite
	@make lint
	@make test-coverage
	@make security-check

security-check: ## Check for security vulnerabilities
	@echo "${YELLOW}Checking security vulnerabilities...${NC}"
	$(COMPOSER) audit
	@echo "${GREEN}✓ Security check complete${NC}"

## Benchmarks
benchmark: ## Run performance benchmarks
	@echo "${YELLOW}Running benchmarks...${NC}"
	$(PHP) bin/gemvc benchmark
	@echo "${GREEN}✓ Benchmarks complete${NC}"

## Cache
cache-clear: ## Clear all caches
	@echo "${YELLOW}Clearing caches...${NC}"
	$(PHP) bin/gemvc cache:clear
	@echo "${GREEN}✓ Caches cleared${NC}"

## Monitoring
logs: ## Tail application logs
	tail -f storage/logs/*.log

metrics: ## Display application metrics
	$(PHP) bin/gemvc metrics:display