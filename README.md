# Drupal Cloud Development Environment

A comprehensive, containerized Drupal development environment that runs entirely in the cloud with web-based VS Code, browser-accessible terminal, and a full Drupal stack.

## 🌟 Features

- **Web-based VS Code** with PHP & Drupal extensions (port 8080)
- **Browser-accessible terminal** via ttyd (port 8084)
- **Complete Drupal 10 stack** with MariaDB, Redis, phpMyAdmin
- **File manager** for easy file operations
- **Development tools**: Composer, Drush, Git, Node.js, npm
- **Xdebug support** for debugging
- **Health checks** and auto-restart policies

## 🚀 Quick Start

### 1. Initialize Environment
```bash
chmod +x init.sh
./init.sh
```

### 2. Start Services
```bash
make up
```

### 3. Install Drupal
```bash
make install-drupal
```

## 📋 Service URLs

| Service | URL | Credentials |
|---------|-----|-------------|
| VS Code (Web) | http://localhost:8080 | Password: `drupal123` |
| Terminal (Web) | http://localhost:8084 | - |
| Drupal Site | http://localhost:8000 | admin / admin123 |
| phpMyAdmin | http://localhost:8081 | root / root123 |
| File Manager | http://localhost:8082 | admin / drupal123 |

## 🛠️ Development Commands

### Service Management
```bash
make up          # Start all services
make down        # Stop all services  
make restart     # Restart all services
make logs        # View service logs
make status      # Show service status
```

### Development
```bash
make cli-shell   # Access CLI container
make web-shell   # Access web container
make clean       # Clean all data
make backup      # Create backup
```

### Drupal Development
```bash
# Access CLI container
make cli-shell

# Inside CLI container:
composer install                    # Install dependencies
drush cr                           # Clear cache
drush uli                          # Get one-time login link
drush sql-dump > backup.sql        # Database backup
drush config:export                # Export configuration
```

## 📁 Directory Structure

```
project-root/
├── drupal/                    # Drupal codebase
├── db/                        # MariaDB data volume
├── redis/                     # Redis data volume  
├── config/                    # Custom configurations
│   ├── php.ini               # PHP settings
│   ├── apache.conf           # Apache configuration
│   └── mysql.cnf             # MySQL settings
├── files/                     # Managed files
├── .devcontainer/            # Docker configurations
├── backups/                  # Backup storage
├── docker-compose.yml        # Main services
├── Makefile                  # Development commands
└── README.md                 # This file
```

## 🔧 CLI Container Features

The CLI container includes:
- **PHP 8.1** with all essential extensions
- **Composer** for dependency management
- **Drush 11** for Drupal management
- **Git, curl, wget, vim** for development
- **Node.js & npm** for frontend tooling
- **Xdebug** for debugging
- **ttyd** for web terminal access

### Terminal Access
- **Web**: http://localhost:8084
- **Direct**: `make cli-shell`
- **Working directory**: `/var/www/html` (Drupal root)

## 🐘 PHP Configuration

### Extensions Included:
- pdo_mysql, gd, xml, mbstring, intl
- curl, redis, opcache, xdebug, bcmath
- zip, json, tokenizer

### Memory & Limits:
- Memory limit: 512M (web), 1G (CLI)
- Upload limit: 64M
- Execution time: 300s (web), unlimited (CLI)

## 🗄️ Database Management

### MariaDB Configuration:
- Host: `mariadb`
- Database: `drupal`
- User: `drupal` / Password: `drupal123`
- Root: `root` / Password: `root123`

### Access Methods:
- **phpMyAdmin**: http://localhost:8081
- **CLI**: `make cli-shell` then `mysql -h mariadb -u drupal -p`

## 🚨 Troubleshooting

### Common Issues:

1. **Permission errors**:
   ```bash
   sudo chown -R $USER:$USER drupal files
   chmod -R 755 drupal
   ```

2. **Services not starting**:
   ```bash
   make down
   docker system prune
   make up
   ```

3. **Database connection issues**:
   ```bash
   make logs mariadb  # Check database logs
   ```

4. **VS Code not loading**:
   - Check if port 8080 is available
   - Try different browser
   - Check container logs: `docker logs drupal_vscode`

## 🔒 Security Notes

- Change default passwords in production
- Xdebug is enabled for development only
- File permissions are set for development convenience
- Use environment variables for sensitive data

## 📚 Additional Resources

- [Drupal Documentation](https://www.drupal.org/docs)
- [Drush Commands](https://drushcommands.com/)
- [Docker Compose Reference](https://docs.docker.com/compose/)

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch
3. Test your changes
4. Submit a pull request

## 📝 License

This project is licensed under the MIT License.