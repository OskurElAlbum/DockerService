#!/bin/bash

DIR="${HOME}/Documents/Docker/Dockerservice"
DIR_JENKINS="${DIR}/services/Jenkins"
USER_SCRIPT=$USER

# Fonctions ###########################################################

echo "1 - Create directories for Jenkins${DIR_JENKINS}/data"
mkdir -p ${DIR_JENKINS}/data

echo "2 - Copy the environment variable and the saved file"
cp $DIR/save/Jenkins/.env ${DIR_JENKINS}

echo "3 - Copy the file from Docker"
cp ${DIR}/docker/jenkins/docker-compose-jenkins.yml ${DIR_JENKINS}
#echo "2 - Create docker-compose file for jenkins"
#echo "
#version: '3'
#
#services:
#  jenkins:
#    image: 'jenkins/jenkins:lts'
#    container_name: jenkins
#    restart: always
#    env_file: .env
#    ports:
#    - \"\${JENKINS_PORT}:8080\"
#    - \"\${JENKINS_PORT2}:8443\"
#    - \"\${JENKINS_PORT3}:50000\"
#    volumes:
#      - 'jenkins_data:/var/jenkins_home/'
#    user: 0:0
#
#volumes:
#  jenkins_data:
#    driver: local
#    driver_opts:
#      o: bind
#      type: none
#      device: ${DIR_JENKINS}/data
#
#" >${DIR_JENKINS}/docker-compose-jenkins.yml

echo "4 - Run jenkins "
docker-compose -f ${DIR_JENKINS}/docker-compose-jenkins.yml up -d

sleep 15s

firefox -p test 127.0.0.1:8080 &
