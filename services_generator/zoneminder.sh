#!/bin/bash

# DIR="${HOME}/Docker/generator"
DIR="${HOME}/Documents/Docker/Dockerservice"
DIR_ZONEMINDER="${DIR}/services/zoneminder"
USER_SCRIPT=$USER

echo "1 - Create directories for ZoneMinder ${DIR_ZONEMINDER}/{control,config,data}"
mkdir -p $DIR_ZONEMINDER/{control,config,data}

echo "2 - Copy the environment variable and the saved file"
cp -rT $DIR/save/zoneminder $DIR_ZONEMINDER

echo "3 - Copy the file from Docker"
cp ${DIR}/docker/zoneminder/docker-compose-CCTV.yml ${DIR_ZONEMINDER}

#echo "3 - Create docker compose for ZoneMinder"
#echo "
#version: '3.0'
#
#services:
#  CCTV-Zoneminder:
#    image: dlandon/zoneminder.machine.learning
#    container_name: CCTV-Zoneminder
#    restart: always
#    env_file: .env
#    ports:
#      - \"\${ZONEMINDER_PORT}:9000/tcp\"
#      - \"\${ZONEMINDER_PORT_WEB}:80/tcp\"
#    volumes:
#      - CCTV_ZM:/var/cache/zoneminder
#      - CCTV_Config:/config
#    environment:
#      - TZ=Europe/Paris
#      - MULTI_PORT_START=0
#      - MULTI_PORT_END=0
#    # networks:
#    #   - generator-CCTV
#
#volumes:
#  CCTV_ZM:
#    driver: local
#    driver_opts:
#      o: bind
#      type: none
#      device: $DIR_ZONEMINDER/control
#
#  CCTV_Config:
#    driver: local
#    driver_opts:
#      o: bind
#      type: none
#      device: $DIR_ZONEMINDER/config
#
## networks:
##   generator-CCTV:
##     driver: bridge
##     ipam:
##       config:
##         - subnet: 192.169.168.0/24
#
#" >$DIR_ZONEMINDER/docker-compose-CCTV.yml

echo "4 - Run CCTV container"
docker-compose -f $DIR_ZONEMINDER/docker-compose-CCTV.yml up -d