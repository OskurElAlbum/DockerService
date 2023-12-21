#!/bin/bash

DIR="${HOME}/Documents/Docker/Dockerservice"
DIR_SQL_DATABASE="${DIR}/services/SQL_Database"
USER_SCRIPT=$USER

# Fonctions ###########################################################

echo "1 - Create directories for SQL Database ${DIR_SQL_DATABASE}/data"
mkdir -p $DIR_SQL_DATABASE/data

echo "2 - Copy the environment variable and the saved file"
cp -rT $DIR/save/SQL_Database $DIR_SQL_DATABASE

echo "3 - Create docker compose for SQL Database"
echo "
version: '3.0'

services:
  SQL_Database_mariadb:
    image: mariadb:latest
    container_name: SQL_Database_Mariadb
    restart: always
    env_file: .env
    ports:
    - \"\${MARIADB_PORT}:3306\"
    volumes:
     - SQL_Database_mariadb_data:/var/lib/mysql/
    environment:
      MYSQL_ROOT_PASSWORD: \"\$MYSQL_ROOT_PASSWORD\"
      MYSQL_DATABASE: \"\$MYSQL_DATABASE\"
      MYSQL_USER: \"\$MYSQL_USER\"
      MYSQL_PASSWORD: \"\$MYSQL_PASSWORD\"    
    networks:
    - SQL_Database_network

  SQL_Database_phpmyadmin:
    image: phpmyadmin
    container_name: SQL_Database_phpmyadmin
    restart: always
    env_file: .env
    ports:
      - \"\$PHPMYADMIN_PORT:80\"
    environment:
      - PMA_ARBITRARY=1
    networks:
    - SQL_Database_network

volumes:
  SQL_Database_mariadb_data:
    driver: local
    driver_opts:
      o: bind
      type: none
      device: $DIR_SQL_DATABASE/data

networks:
  SQL_Database_network:
    driver: bridge
    ipam:
      config:
        - subnet: 192.168.168.0/24

" >$DIR_SQL_DATABASE/docker-compose-SQLDatabase.yml

echo "4 - Run SQL-Database"
docker-compose -f $DIR_SQL_DATABASE/docker-compose-SQLDatabase.yml up -d