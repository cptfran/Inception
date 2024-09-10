WORDPRESS_DATA = /home/data/wordpress
MARIADB_DATA = /home/data/mariadb

all: up

up: build
	@mkidr -p $(WORDPRESS_DATA)
	@mkdir -p $(MARIADB_DATA)
	docker-compose -f ./docker-compose.yml up -d

down:
	docker-compose -f ./docker-compose.yml down

stop:
	docker-compose -f ./docker-compose.yml stop

start:
	docker-compose -f ./docker-compose.yml start

build:
	docker-compose -f ./docker-compose.yml build

clean:
	@docker stop $$(docker ps -qa) || true
	@docker rm $$(docker ps -qa) || true
	@docker rmi -f $$(docker images -qa) || true
	@docker volume rm $$(docker volume ls -q) || true
	@docker network rm $$(docker network ls -q) || true
	@rm -rf $(WORDPRESS_DATA) || true
	@rm -rf $(MARIADB_DATA) || true

re: clean up

prune: clean
	@docker system prune -a --volumes -f

