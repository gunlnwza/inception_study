NAME 					= inception

DC						= docker-compose
DC_FILE					= ./srcs/docker-compose.yml


all: 					build up 


build:					
						mkdir -p /home/bworrawa/data/mariadb  /home/bworrawa/data/wordpress /home/bworrawa/data/static /home/bworrawa/data/sftp 
						sudo chown -R 1000:1000 /home/bworrawa/data
						sudo chmod -R 755 /home/bworrawa/data
						$(DC) -f $(DC_FILE) build 

stop:
						$(DC) -f $(DC_FILE) stop 

start:
						$(DC) -f $(DC_FILE) start


up:						
						$(DC) -f $(DC_FILE) up -d 

down:
						$(DC) -f $(DC_FILE) down 

clean:					
						$(DC) -f $(DC_FILE) down --volumes --remove-orphans --rmi all 
						sudo rm -rf /home/bworrawa/data/wordpress /home/bworrawa/data/mariadb /home/bworrawa/data/static /home/bworrawa/data/sftp

.PHONY: 				all clean build fclean re stop start up down
