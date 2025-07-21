#!/bin/bash

set -e

echo "🐳 Initializing Drupal Cloud Development Environment..."
echo ""

# Create directory structure
echo "📁 Creating directory structure..."
mkdir -p drupal
mkdir -p db
mkdir -p redis
mkdir -p config
mkdir -p files
mkdir -p .devcontainer
mkdir -p backups

# Set proper permissions
echo "🔐 Setting permissions..."
chmod 755 drupal files
chmod 777 db redis

# Create docker-compose override for development if it doesn't exist
if [ ! -f docker-compose.override.yml ]; then
    cat > docker-compose.override.yml << 'EOL'
version: '3.8'

services:
  cli:
    # Add any development-specific overrides here
    environment:
      - XDEBUG_MODE=debug
      - XDEBUG_CONFIG=client_host=host.docker.internal

  web:
    environment:
      - XDEBUG_MODE=debug  
      - XDEBUG_CONFIG=client_host=host.docker.internal
EOL
fi

# Create .env file if it doesn't exist
if [ ! -f .env ]; then
    cat > .env << 'EOL'
# Drupal Database Configuration
DRUPAL_DB_HOST=mariadb
DRUPAL_DB_USER=drupal
DRUPAL_DB_PASSWORD=drupal123
DRUPAL_DB_NAME=drupal

# MySQL Root Password
MYSQL_ROOT_PASSWORD=root123

# Redis Configuration
REDIS_HOST=redis

# VS Code Password
VSCODE_PASSWORD=drupal123

# File Manager Credentials
FILEBROWSER_USERNAME=admin
FILEBROWSER_PASSWORD=drupal123
EOL
fi

echo ""
echo "✅ Initialization complete!"
echo ""
echo "🚀 Next steps:"
echo "1. Run: make up                # Start all services"
echo "2. Run: make install-drupal    # Install Drupal 10"
echo "3. Open: http://localhost:8080 # VS Code in browser"
echo ""
echo "📖 For more commands, run: make help"