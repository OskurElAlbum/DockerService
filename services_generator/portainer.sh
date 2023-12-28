#!/bin/bash

DIR="${HOME}/Documents/Docker/Dockerservice"
DIR_PORTAINER="${DIR}/services/portainer"
USER_SCRIPT=$USER

# Fonctions ###########################################################

# echo "1 - Create directories ${DIR}/services/portainer/"
# mkdir -p $DIR/services/portainer/

echo "1 - Create directories ${DIR_PORTAINER}"
mkdir -p $DIR_PORTAINER

echo "2 - Copy the environment variable"
cp -rT $DIR/save/portainer $DIR_PORTAINER

echo "3 - Copy the file from Docker"
cp ${DIR}/docker/portainer/docker-compose-portainer.yml ${DIR_PORTAINER}
#potentiel problème avec la socket Docker
#echo "3 - Create docker compose for portainer"
#echo "
#version: '3'
#
#services:
#  portainer:
#    container_name: portainer
#    image: portainer/portainer-ce
#    restart: always
#    env_file: .env
#    ports:
#      - \"\${DOCKER_PORTAINER_PORT}:9000\"
#    volumes:
#      - /var/run/docker.sock:/var/run/docker.sock
#
#" >$DIR_PORTAINER/docker-compose-portainer.yml
# " >$DIR/services/portainer/docker-compose-portainer.yml


echo "4 - Run portainer"
docker-compose -f $DIR_PORTAINER/docker-compose-portainer.yml up -d