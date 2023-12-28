#!/bin/bash

DIR="${HOME}/Documents/Docker/Dockerservice"
DIR_GITLAB="${DIR}/services/gitlab"
USER_SCRIPT=$USER

# Fonctions ###########################################################

echo "1 - Create directories ${DIR_GITLAB}/{config,data,logs}"
mkdir -p ${DIR_GITLAB}/{config,data,logs}

echo "2 - Copy the environment variable and the saved file"
cp ${DIR}/save/gitlab/.env ${DIR_GITLAB}

echo "3 - Copy the file from Docker"
cp ${DIR}/docker/gitlab/docker-compose-gitlab.yml ${DIR_GITLAB}
#echo "3 - Create docker compose for gitlab "
#echo "
#version: '3.0'
#
#services:
#  gitlab:
#    image: gitlab/gitlab-ce:latest
#    container_name: gitlab
#    restart: always
#    env_file: .env
#    ports:
#    - \"\${GITLAB_PORT}:80\"
#  #  - \"\${GITLAB_PORT2}:443\"
#    - \"\${GITLAB_PORT3}:5000\"
#    volumes:
#     - gitlab_config:/etc/gitlab/
#     - gitlab_logs:/var/log/gitlab/
#     - gitlab_data:/var/opt/gitlab/
#  #   networks:
#  #   - gitlab_networks
#  #   hostname: 'gitlab.example.com'
#  #   environment:
#  #     GITLAB_OMNIBUS_CONFIG: |
#  #       external_url 'https://gitlab.example.com'
#  #   expose:
#  #   - 5000
#
#volumes:
#  gitlab_data:
#    driver: local
#    driver_opts:
#      o: bind
#      type: none
#      device: ${DIR_GITLAB}/data
#  gitlab_logs:
#    driver: local
#    driver_opts:
#      o: bind
#      type: none
#      device: ${DIR_GITLAB}/logs
#  gitlab_config:
#    driver: local
#    driver_opts:
#      o: bind
#      type: none
#      device: ${DIR_GITLAB}/config
#" >${DIR_GITLAB}/docker-compose-gitlab.yml

echo "4 - Run gitlab"
docker-compose -f ${DIR_GITLAB}/docker-compose-gitlab.yml up -d

echo "Add ip of gitlab container and url gitlab.example.com in your /etc/hosts :
in your host machine:
docker inspect gitlab
Take the IPAddress of the container
edit the hosts file:
sudo nano /etc/hosts
add the line:
(yourIPAdress) gitlab.example.com"