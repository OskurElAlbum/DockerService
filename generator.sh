#!/bin/bash

# DIR="${HOME}/Docker/generator"
DIR="${HOME}/Documents/Docker/Dockerservice"
USER_SCRIPT=$USER

# Fonctions ###########################################################

help_list() {
  echo "Usage:

  ${0##*/} [-h][--prometheus][--grafana]

Options:

  -h, --help
    can I help you ?

  -a, --api
    run api for test

  -i, --ip
    list ip for each container

  -por, --portainer
  run portainer container

  -mine, --minecraft
    run minecraft container

  -CCTV, --CCTVZoneminder
    run a CCTV ZoneMinder container and a monitoring tool asociate

  -sql, --SQLDatabase
    run a SQL database and a monitoring tool asociate

  -web, --webapplication
    run a Webapplication services

  -iot, --IotMonitoring
      run a Iot monitoring services

  -j, --jenkins
      run jenkins container

  -g, --gitlab
    run gitlab container

  -php, --phpMyAdmin
    run phpMyAdmin container
  "
}

parse_options() {
  case $@ in
    -h|--help)
      help_list
      exit
     ;;
    -a|--api)
      api
      ;;
    -i|--ip)
      ip
      ;;
    -por|--portainer)
      portainer
      ;;
    -mine|--minecraft)
      minecraft
      ;;
    -CCTV|--CCTVZoneminder)
      CCTV
      ;;
        -sql|--SQLDatabase)
      SQLDatabase
      ;;
    -web|--webapplication)
      Webapp
      ;;
    -iot|--IotMonitoring)
      IotMonitoring
      ;;
    -j|--jenkins)
      jenkins
      ;;
    -g|--gitlab)
      gitlab
      ;;
    -php|--phpMyAdmin)
      phpMyAdmin
      ;;
    *)
      echo "Unknown option: ${opt} - Run ${0##*/} -h for help.">&2
      exit 1
  esac
}


ip() {
for i in $(docker ps -q); do docker inspect -f "{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}} - {{.Name}}" $i;done
}

api() {
  docker run -d --name httpbin -p 9999:80 kennethreitz/httpbin
  firefox -p test 127.0.0.1:9999 &
}

portainer(){
  echo "Install Portainer"
  source $DIR/services_generator/portainer.sh
}

minecraft() {
  echo "Install Minecraft"
  source $DIR/services_generator/minecraft.sh
}

CCTV(){
  echo "Install ZoneMinder"
  source $DIR/services_generator/zoneminder.sh
}

SQLDatabase(){
  echo "Install SQLDatabase"
  source $DIR/services_generator/SQL_Database.sh
}

Webapp() {
  echo "Install Webapplication"
  source $DIR/services_generator/web_Application.sh
}

IotMonitoring() {
  echo "Install Iot monitoring service"
  source "${DIR}"/services_generator/iot_Monitoring.sh
}

jenkins() {
  echo "Install Jenkins Server"
  source "${DIR}"/services_generator/jenkins.sh
}

gitlab() {
  echo "Install gitlab Server"
  source "${DIR}"/services_generator/gitlab.sh
}

phpMyAdmin() {
  echo "Install phpmyadmin Server"
  source "${DIR}"/services_generator/phpmyadmin.sh
}

# Let's Go !! parse args  ####################################################################

parse_options $@

ip
