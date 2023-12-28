#!/bin/bash


DIR="${HOME}/Documents/Docker/Dockerservice"
DIR_WEP_APPLICATION="${DIR}/services/web_Application"
USER_SCRIPT=$USER

# Fonctions ###########################################################

echo "1 - Create directories for webapp ${DIR_WEP_APPLICATION}/www"
mkdir -p $DIR_WEP_APPLICATION/www
# chmod 775 -R $DIR/web-application/

echo "2 - Create directories for nginx ${DIR_WEP_APPLICATION}/nginx/{config,log}"
mkdir -p $DIR_WEP_APPLICATION/nginx/{config,log}
# chmod 775 -R $DIR/nginx/

echo "3 - Copy the environment variable,nginx website and saved file"
cp $DIR/save/web_Application/.env $DIR_WEP_APPLICATION
cp -rT $DIR/save/web_Application/web_Application_www_Save $DIR_WEP_APPLICATION/www
cp -rT $DIR/save/web_Application/web_Application_Nginx_Conf_Save $DIR_WEP_APPLICATION/nginx/config

echo "3 - Copy the file from Docker"
cp ${DIR}/docker/web_Application/docker-compose-webapplication.yml ${DIR_WEP_APPLICATION}
#echo "4 - Create docker compose for web-application"
#echo "
#version: '3.0'
#
#services:
#  web_Application_nginx:
#    image: nginx:latest
#    container_name: web_Application_EngineX
#    restart: always
#    env_file: .env
#    ports:
#      - \"\${NGINX_PORT}:80\"
#    volumes:
#      - web_Application_website:/usr/share/nginx/html
#      - web_Application_nginx_conf:/etc/nginx/conf.d
#    networks:
#     - web_Application_network
#
#  # web_Application_php:
#  #   image: php:fpm
#  #   container_name: web_Application_php
#  #   restart: always
#  #   env_file: .env
#  #   ports:
#  #     - \"\${PHP_PORT}:9000\"
#  #   volumes:
#  #     - web_Application_website:/usr/share/nginx/html
#  #   networks:
#  #    - web_Application_network
#  #   # stdin_open: true
#  #   # tty: true
#
#volumes:
#  web_Application_website:
#    driver: local
#    driver_opts:
#      o: bind
#      type: none
#      device: $DIR_WEP_APPLICATION/www
#
#  web_Application_nginx_conf:
#    driver: local
#    driver_opts:
#      o: bind
#      type: none
#      device: $DIR_WEP_APPLICATION/nginx/config
#
#networks:
#  web_Application_network:
#    driver: bridge
#    ipam:
#      config:
#        - subnet: 192.168.169.0/24
#" >$DIR_WEP_APPLICATION/docker-compose-webapplication.yml

echo "5 - Run web Application"
docker-compose -f $DIR_WEP_APPLICATION/docker-compose-webapplication.yml up -d #$DIR/composefile/docker-compose-nginx.yml up -d