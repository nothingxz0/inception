# Developer Documentation

## Project structure

The project is organized around the three mandatory services:

```text
.
├── Makefile
├── README.md
├── USER_DOC.md
├── DEV_DOC.md
├── secrets/
└── srcs/
    ├── docker-compose.yml
    └── requirements/
        ├── mariadb/
        │   ├── Dockerfile
        │   ├── conf/
        │   └── tools/
        ├── nginx/
        │   ├── Dockerfile
        │   ├── conf/
        │   └── tools/
        └── wordpress/
            ├── Dockerfile
            ├── conf/
            └── tools/
```

The Dockerfiles are located inside each service directory. Service-specific configuration files are stored in `conf/`, and initialization/entrypoint scripts are stored in `tools/`.

## Prerequisites

The development machine must have:

- Docker
- Docker Compose
- GNU Make
- A Linux environment suitable for the 42 project

The project uses Debian Bookworm as the base distribution for the mandatory service images.

## Configuration

The main Compose configuration is:

```text
srcs/docker-compose.yml
```

It defines three services:

```text
mariadb
wordpress
nginx
```

All three services are connected to the custom bridge network:

```text
inception-network
```

Only NGINX publishes a host port:

```text
443:443
```

WordPress communicates with NGINX through PHP-FPM on port `9000`, while WordPress communicates with MariaDB through the Docker network.

## Environment configuration

Non-sensitive configuration is supplied through environment variables, including values such as:

```text
DOMAIN_NAME
MYSQL_DATABASE
MYSQL_USER
WP_ADMIN_USER
WP_ADMIN_EMAIL
WP_USER
WP_USER_EMAIL
```

The actual local `.env` file should not be committed to Git.

Create/configure the local environment according to the variables referenced by `srcs/docker-compose.yml`.

## Secrets

Passwords are provided as Docker secrets. The Compose configuration expects secret files for:

```text
db_root_password.txt
db_password.txt
wp_admin_password.txt
wp_user_password.txt
```

These files are stored locally under the project's `secrets/` directory and must not be committed to the repository.

The repository `.gitignore` excludes the sensitive configuration.

## Building the images

The project builds a separate custom image for each mandatory service.

Build all services with:

```bash
make build
```

Or directly with Compose:

```bash
docker compose -f srcs/docker-compose.yml build
```

The service image names are defined in the Compose file.

## Starting the stack

```bash
make up
```

Or:

```bash
docker compose -f srcs/docker-compose.yml up -d
```

Check the state:

```bash
docker compose -f srcs/docker-compose.yml ps
```

## Stopping the stack

```bash
make down
```

This removes the containers and Compose network but keeps persistent data.

## Makefile commands

The Makefile provides the following main targets:

### `make`

Builds the images and starts the stack.

### `make build`

Creates the persistent data directories and builds the service images.

### `make up`

Starts the Compose services in detached mode.

### `make down`

Stops and removes the Compose containers and network.

### `make clean`

Runs `make down` and performs Docker system cleanup.

### `make fclean`

Runs the cleanup and removes the project's persistent data directory.

### `make re`

Runs the full cleanup and then rebuilds and starts the project.

## Persistent storage

The Compose configuration defines two named volumes:

```text
mariadb_data
wordpress_data
```

They are backed by host directories:

```text
/home/<USER>/data/mariadb
/home/<USER>/data/wordpress
```

The MariaDB volume is mounted at:

```text
/var/lib/mysql
```

The WordPress volume is mounted at:

```text
/var/www/html
```

The purpose is to keep application and database data independent from the lifetime of the containers.

Do not manually delete these directories unless you intentionally want to destroy the persistent project data.

## Service development

### MariaDB

The MariaDB Dockerfile installs the database server and uses the project initialization script to prepare the database and user before starting MariaDB in the foreground.

Configuration is located in:

```text
srcs/requirements/mariadb/conf/
```

Initialization scripts are located in:

```text
srcs/requirements/mariadb/tools/
```

### WordPress

The WordPress image installs WordPress and the PHP-FPM runtime together with the PHP extensions required to communicate with MariaDB.

The PHP-FPM service listens internally on port `9000` and is kept in the foreground so the container has a long-running main process.

Configuration is located in:

```text
srcs/requirements/wordpress/conf/
```

Scripts are located in:

```text
srcs/requirements/wordpress/tools/
```

### NGINX

NGINX is the public-facing service. It terminates TLS and forwards PHP requests to the WordPress container through FastCGI.

The NGINX configuration is located in:

```text
srcs/requirements/nginx/conf/
```

The NGINX container exposes HTTPS on port `443`.

## Network design

The three services use the custom Docker bridge network:

```text
inception-network
```

Containers can reach each other by Compose service name. For example, NGINX can forward requests to the WordPress service using its service name rather than a hard-coded container IP.

The project does not use host networking or legacy Docker links.

## Debugging

Check all services:

```bash
docker ps -a
```

Inspect logs:

```bash
docker compose -f srcs/docker-compose.yml logs
```

Inspect a single service:

```bash
docker compose -f srcs/docker-compose.yml logs nginx
docker compose -f srcs/docker-compose.yml logs wordpress
docker compose -f srcs/docker-compose.yml logs mariadb
```

Inspect the final Compose configuration:

```bash
docker compose -f srcs/docker-compose.yml config
```

Inspect networks:

```bash
docker network ls
docker network inspect inception_inception-network
```

Inspect volumes:

```bash
docker volume ls
docker volume inspect inception_mariadb_data
docker volume inspect inception_wordpress_data
```

The exact Compose-generated resource names may vary depending on the project directory name.

## Rebuilding after changes

After changing a Dockerfile or service build configuration:

```bash
make build
make up
```

For a completely clean rebuild:

```bash
make re
```

Remember that `make re` removes persistent data, so it should not be used when you need to preserve the current WordPress installation or database.

## HTTPS and certificates

NGINX is configured for HTTPS and supports TLS 1.2 and TLS 1.3.

The certificate and key are used only by the NGINX service. Certificate files and private keys should never be committed if they contain private material.

## Development notes

When modifying the project:

1. Keep each service in its own container.
2. Keep service-specific configuration inside its corresponding requirement directory.
3. Do not install a second mandatory service inside another service's container.
4. Do not put passwords directly into Dockerfiles or source-controlled configuration.
5. Keep persistent data outside the container filesystem.
6. Keep long-running container processes in the foreground.
7. Test the complete stack after configuration changes.

## AI usage

AI assistance was used as a development and learning tool to understand technologies, troubleshoot configuration issues, review implementation choices and improve documentation. The resulting configuration was reviewed and adapted to the project's requirements and tested by the student.
