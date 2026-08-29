COMPOSE = docker compose -f srcs/docker-compose.yml
DATA_DIR = /home/$(USER)/data

.PHONY: all build up down clean fclean re

all: build up

$(DATA_DIR)/mariadb:
	mkdir -p $(DATA_DIR)/mariadb

$(DATA_DIR)/wordpress:
	mkdir -p $(DATA_DIR)/wordpress

build: $(DATA_DIR)/mariadb $(DATA_DIR)/wordpress
	$(COMPOSE) build

up:
	$(COMPOSE) up -d

down:
	$(COMPOSE) down

clean: down
	docker system prune -af

fclean: clean
	docker volume prune -f
	sudo rm -rf $(DATA_DIR)

re: fclean all