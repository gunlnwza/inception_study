NAME = inception

all: up

up:
	docker-compose -f srcs/docker-compose.yml up -d --build

down:
	docker-compose -f srcs/docker-compose.yml down

clean:
	docker system prune -af
	docker volume prune -f

fclean: down clean
	rm -rf /home/${INCEPTION_LOGIN}/data/mariadb_data/*
	rm -rf /home/${INCEPTION_LOGIN}/data/wordpress_data/*

re: fclean up

.PHONY: all up down clean fclean re
