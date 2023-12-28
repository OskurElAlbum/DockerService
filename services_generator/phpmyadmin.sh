#!/bin/bash

DIR="${HOME}/Documents/Docker/Dockerservice"
DIR_PHP_MYADMIN="${DIR}/services/Php_myadmin"
USER_SCRIPT=$USER

# Fonctions ###########################################################

#echo "1 - Copy the environment variable and the saved file"
#cp -rT $DIR/save/SQL_Database $DIR_PHP_MYADMIN

echo "1 - Create directories for SQL Database ${$DIR_PHP_MYADMIN}"
mkdir -p $DIR_PHP_MYADMIN

echo "2 - Create docker compose for SQL Database"
echo "
version: '3.0'

services:
  PhpMyAdmin:
    image: phpmyadmin
    container_name: PhpMyAdmin
    restart: always
#    env_file: .env
    ports:
      - 50:80
    environment:
      - PMA_ARBITRARY=1
    networks:
    - iot_monitoring_Iot_Monitoring_network


networks:
  iot_monitoring_Iot_Monitoring_network:
    external: true
#  SQL_Database_network:
#    driver: bridge
#    ipam:
#      config:
#        - subnet: 192.168.170.0/24
" >$DIR_PHP_MYADMIN/docker-compose-PhpMyAdmin.yml

echo "4 - Run SQL-Database"
docker-compose -f $DIR_PHP_MYADMIN/docker-compose-PhpMyAdmin.yml up -d