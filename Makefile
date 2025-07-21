.PHONY: help build up down restart logs shell web-shell cli-shell install-drupal clean backup

help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-15s %s\n", $$1, $$2}\' $(MAKEFILE_LIST)

build: ## Build all Docker images
	docker-compose build --no-cache

up: ## Start all services
	docker-compose up -d
	@echo ""
	@echo "🚀 Drupal Development Environment Started!"
	@echo ""
	@echo "📋 Service URLs:"
	@echo "   VS Code (Web):     http://localhost:8080 (password: drupal123)"
	@echo "   Terminal (Web):    http://localhost:8084"
	@echo "   Drupal Site:       http://localhost:8000"
	@echo "   phpMyAdmin:        http://localhost:8081"
	@echo "   File Manager:      http://localhost:8082 (admin/drupal123)"
	@echo ""
	@echo "🛠️  Quick Commands:"
	@echo "   make install-drupal  # Install Drupal via Composer & Drush"
	@echo "   make cli-shell       # Access CLI container"
	@echo "   make logs            # View all service logs"

down: ## Stop all services
	docker-compose down

restart: ## Restart all services
	docker-compose restart

logs: ## Show logs for all services
	docker-compose logs -f

shell: cli-shell ## Access CLI container shell

web-shell: ## Access web container shell
	docker-compose exec web bash

cli-shell: ## Access CLI container shell
	docker-compose exec cli bash

install-drupal: ## Install Drupal 10 via Composer and Drush
	@echo "🔧 Installing Drupal 10..."
	docker-compose exec cli bash -c "rm -rf /var/www/html/* /var/www/html/.[^.]*"
	docker-compose exec cli bash -c "composer create-project drupal/recommended-project:^10 . --no-interaction --prefer-dist"
	docker-compose exec cli bash -c "chmod -R 755 web/sites/default"
	docker-compose exec cli bash -c "mkdir -p web/sites/default/files && chmod -R 777 web/sites/default/files"
	@echo ""
	@echo "🗄️  Installing Drupal database..."
	docker-compose exec cli drush site:install standard \
		--db-url=mysql://drupal:drupal123@mariadb/drupal \
		--site-name="Drupal Development\" \
		--account-name=admin \
		--account-pass=admin123 \
		--yes
	@echo ""
	@echo "✅ Drupal installation complete!"
	@echo "   Site: http://localhost:8000"
	@echo "   Admin: admin / admin123"

clean: ## Stop services and remove all data
	docker-compose down -v
	sudo rm -rf drupal/* db/* redis/*
	@echo "🧹 Environment cleaned!"

backup: ## Create backup of current setup
	@mkdir -p backups
	@backup_name="drupal_backup_$$(date +%Y%m%d_%H%M%S)"; \
	tar -czf "backups/$$backup_name.tar.gz" drupal db redis config; \
	echo "💾 Backup created: backups/$$backup_name.tar.gz"

status: ## Show status of all services
	@echo "📊 Service Status:"
	docker-compose ps