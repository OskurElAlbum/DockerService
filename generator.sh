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

# Let's Go !! parse args  ####################################################################

parse_options $@

ip
