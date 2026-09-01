# User Documentation

## Overview

This project provides a WordPress website through three Docker containers:

- **NGINX** — HTTPS entry point on port 443.
- **WordPress** — WordPress application running with PHP-FPM.
- **MariaDB** — database used by WordPress.

The services communicate through the project's Docker network and WordPress/MariaDB data is persisted on the host.

## Starting the project

From the root of the repository:

```bash
make
```

To start the services directly:

```bash
make up
```

Check that the containers are running:

```bash
docker ps
```

You should see the `nginx`, `wordpress` and `mariadb` containers.

## Accessing the website

The website is served through HTTPS on port `443`.

Open the configured domain in a browser:

```text
https://<DOMAIN_NAME>
```

Replace `<DOMAIN_NAME>` with the domain configured for the project.

For a local 42 setup, make sure the domain resolves to the machine running the project before opening it in the browser.

## WordPress

The WordPress installation is configured using the values supplied to the WordPress container.

There are two WordPress users configured by the project:

- An **administrator** account with access to the WordPress administration dashboard.
- A normal **user** account.

The administrator username and email are configured through the corresponding environment variables. Their passwords are supplied through Docker secrets.

The WordPress administration interface is available at:

```text
https://<DOMAIN_NAME>/wp-admin/
```

Use the administrator credentials configured for the project.

## Checking the services

List running containers:

```bash
docker ps
```

View all Compose services:

```bash
docker compose -f srcs/docker-compose.yml ps
```

View logs:

```bash
docker compose -f srcs/docker-compose.yml logs
```

View one service's logs:

```bash
docker compose -f srcs/docker-compose.yml logs nginx
docker compose -f srcs/docker-compose.yml logs wordpress
docker compose -f srcs/docker-compose.yml logs mariadb
```

## Stopping the project

To stop and remove the containers and network while keeping persistent data:

```bash
make down
```

## Restarting

Start the existing containers again with:

```bash
make up
```

If you want to rebuild the images:

```bash
make build
make up
```

## Persistent data

The project stores persistent data outside the containers under:

```text
/home/<USER>/data/mariadb
/home/<USER>/data/wordpress
```

The MariaDB directory contains database data. The WordPress directory contains the WordPress site data.

Removing containers does not remove this persistent data when using `make down`.

## Full cleanup

`make fclean` performs a more destructive cleanup:

```bash
make fclean
```

It removes Docker resources selected by the Makefile and deletes the project's persistent data directory. This means WordPress and MariaDB data will be lost.

Use this command only when you intentionally want to start again from an empty installation.

## Credentials and secrets

Passwords are provided through Docker secrets rather than being written directly into Dockerfiles.

Do not commit passwords, `.env` files or the `secrets/` directory to the repository.

If credentials need to be changed, update the local secret/configuration files and recreate the relevant services as required.

## Useful commands

### Enter a container

```bash
docker exec -it nginx bash
docker exec -it wordpress bash
docker exec -it mariadb bash
```

### Inspect the Compose configuration

```bash
docker compose -f srcs/docker-compose.yml config
```

### Remove stopped containers

```bash
docker compose -f srcs/docker-compose.yml down
```

### Rebuild everything from scratch

```bash
make re
```

`make re` is destructive because it performs the full cleanup before rebuilding.
