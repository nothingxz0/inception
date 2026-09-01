*This project has been created as part of the 42 curriculum by nothingxz0.*

# Inception

## Description

Inception is a Docker-based infrastructure project. The goal is to build a small WordPress website using multiple dedicated services running in separate Docker containers.

The mandatory stack contains three services:

- **NGINX**: the only public entry point. It serves HTTPS traffic on port 443 and forwards PHP requests to WordPress.
- **WordPress + PHP-FPM**: runs the WordPress application.
- **MariaDB**: stores the WordPress database.

The services communicate through a dedicated Docker bridge network. Persistent data is stored outside the containers through Docker volumes backed by directories under `/home/<USER>/data/`.

The project uses custom Dockerfiles for every service and does not rely on pre-built service images for the application containers.

### Architecture

```text
                    HTTPS :443
                         |
                         v
                 +---------------+
                 |     NGINX     |
                 +---------------+
                         |
                    FastCGI :9000
                         |
                         v
                 +---------------+
                 |   WordPress   |
                 |   PHP-FPM     |
                 +---------------+
                         |
                      MySQL
                         |
                         v
                 +---------------+
                 |    MariaDB    |
                 +---------------+

          All services are connected through
             the inception-network bridge.
```

## Instructions

### Requirements

You need:

- Docker
- Docker Compose
- GNU Make
- A Linux environment

### Configuration

The Compose file is located at:

```text
srcs/docker-compose.yml
```

Configuration values are provided through environment variables and Docker secrets. Sensitive files such as `.env` and `secrets/` must not be committed to Git.

The domain is configured through `DOMAIN_NAME`. For a local 42 setup, make sure the domain resolves to the machine running the project.

### Build and start

From the repository root:

```bash
make
```

This creates the persistent data directories, builds the images and starts the services.

You can also use:

```bash
make build
make up
```

### Stop

```bash
make down
```

### Clean containers and unused Docker resources

```bash
make clean
```

### Full cleanup

```bash
make fclean
```

This also removes the project's persistent data directory. Use it only when you intentionally want to remove the stored MariaDB and WordPress data.

### Rebuild from scratch

```bash
make re
```

### Check the running containers

```bash
docker ps
```

### Check logs

```bash
docker compose -f srcs/docker-compose.yml logs
```

The website is exposed through HTTPS on port `443`.

## Resources

This project relies on the official documentation of Docker, Docker Compose, NGINX, WordPress, PHP-FPM and MariaDB, as well as the 42 Inception subject.

### Docker

Docker provides container isolation and the tools used to build and run the services.

### NGINX

NGINX is used as the HTTPS reverse proxy and forwards PHP requests to the WordPress PHP-FPM service.

### WordPress

WordPress is the CMS used for the website and communicates with MariaDB for persistent application data.

### MariaDB

MariaDB provides the relational database used by WordPress.

### Docker concepts studied

**Virtual machines vs Docker:** a virtual machine normally virtualizes an entire operating system with its own kernel. Docker containers share the host kernel and isolate applications and their dependencies, making containers generally lighter and faster to start.

**Secrets vs environment variables:** environment variables are useful for configuration, but passwords and other sensitive credentials should be handled as Docker secrets so they are not unnecessarily exposed as normal configuration values.

**Docker Network vs Host Network:** the project uses a dedicated bridge network so containers can communicate with each other using their service names while remaining isolated from the host network. Host networking would remove this network isolation and directly use the host network namespace.

**Docker Volumes vs Bind Mounts:** Docker volumes are managed by Docker, while bind mounts map an explicit host path into a container. This project uses local Docker volumes configured with bind options so persistent data is stored under `/home/<USER>/data/`.

## AI Usage

AI tools were used as a learning and development aid during the project. They were used to help understand Docker, Docker Compose, NGINX, PHP-FPM, MariaDB and WordPress concepts, troubleshoot errors, review configuration choices and clarify documentation.

The project was implemented and tested by the student. AI-generated suggestions were reviewed and adapted to the requirements of the Inception subject rather than being blindly copied.
