#!/bin/bash


# DIR="${HOME}/Docker/generator"
DIR="${HOME}/Dockerservice"
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
  
  -j, --jenkins
    run jenkins container

  -g, --gitlab
    run gitlab container 

  -p, --postgres
    run postgres 

  -m, --mariadb
  run mariadb

  -pro, --prometheus
    run prometheus container

  -gra, --grafana
    run grafana container

  -mos, --mosquitto
    run mosquitto container

  -por, --portainer
    run portainer container

  -mine, --minecraft
    run minecraft container

  -web, --webapplication
    run a Webapplication services

  -sql, --SQLDatabase
    run a SQL database and a monitoring tool asociate
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
    -j|--jenkins)
      jenkins
      ;;
    -g|--gitlab)
      gitlab
      ;;
    -p|--postgres)
      postgres
      ;;
    -m|--mariadb)
      mariadb
      ;;
    -pro|--prometheus)
      prometheus
      ;;
    -gra|--grafana)
      grafana
      ;;
    -mos|--mosquitto)
      mosquitto
      ;;
    -por|--portainer)
      portainer
      ;;
    -mine|--minecraft)
      minecraft
      ;;
    -web|--webapplication)
      Webapp
      ;;
    -sql|--SQLDatabase)
      SQLDatabase
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

jenkins() {

echo
echo "Install Jenkins"

echo "1 - Create directories ${DIR}/jenkins/"
mkdir -p $DIR/jenkins/

echo "2 - Create docker-compose file"
echo "
version: '3'
services:
  jenkins:
    image: 'jenkins/jenkins:lts'
    container_name: jenkins
    user: 0:0
    ports:
      - '8080:8080'
      - '443:8443'
      - '50000:50000'
    volumes:
      - 'jenkins_data:/var/jenkins_home/'
    networks:
     - generator
volumes:
  jenkins_data:
    driver: local
    driver_opts:
      o: bind
      type: none
      device: ${DIR}/jenkins/
networks:
  generator:
   driver: bridge
   ipam:
     config:
       - subnet: 192.168.168.0/24
" >$DIR/docker-compose-jenkins.yml

echo "3 - Run jenkins "
docker-compose -f $DIR/docker-compose-jenkins.yml up -d

sleep 15s

firefox -p test 127.0.0.1:8080 &
}

gitlab() {

echo
echo "Install Gitlab"

echo "1 - Create directories ${DIR}/gitlab/"
mkdir -p $DIR/gitlab/{config,data,logs}

echo "2 - Create docker compose for gitlab "
echo "
version: '3.0'
services:
  gitlab:
   image: 'gitlab/gitlab-ce:latest'
   container_name: gitlab
   hostname: 'gitlab.example.com'
  #  environment:
  #    GITLAB_OMNIBUS_CONFIG: |
  #      external_url 'https://gitlab.example.com'
   expose: 
   - 5000
   ports:
   - 80:80
   - 443:443
   - 5000:5000
   volumes:
   - gitlab_config:/etc/gitlab/
   - gitlab_logs:/var/log/gitlab/
   - gitlab_data:/var/opt/gitlab/
   networks:
   - generator     
volumes:
  gitlab_data:
    driver: local
    driver_opts:
      o: bind
      type: none
      device: ${DIR}/gitlab/data
  gitlab_logs:
    driver: local
    driver_opts:
      o: bind
      type: none
      device: ${DIR}/gitlab/logs
  gitlab_config:
    driver: local
    driver_opts:
      o: bind
      type: none
      device: ${DIR}/gitlab/config
networks:
  generator:
   driver: bridge
   ipam:
     config:
       - subnet: 192.168.168.0/24
" >$DIR/gitlab/docker-compose-gitlab.yml

echo "3 - Run gitlab"
docker-compose -f $DIR/gitlab/docker-compose-gitlab.yml up -d

echo "Add ip of gitlab container and url gitlab.example.com in your /etc/hosts :
in your host machine:
docker inspect gitlab
Take the IPAddress of the container
edit the hosts file:
sudo nano /etc/hosts
add the line:
(yourIPAdress) gitlab.example.com"

}

postgres() {

echo
echo "Install Postgres"

echo "1 - Create directories ${DIR}/generator/postgres/"
mkdir -p $DIR/postgres/

echo "
version: '3.0'
services:
  postgres:
   image: postgres:latest
   container_name: postgres
   environment:
   - POSTGRES_USER=myuser
   - POSTGRES_PASSWORD=myuserpassword
   - POSTGRES_DB=mydb
   ports:
   - 5432:5432
   volumes:
   - postgres_data:/var/lib/postgresql/
   networks:
   - generator     
volumes:
  postgres_data:
    driver: local
    driver_opts:
      o: bind
      type: none
      device: ${DIR}/postgres
networks:
  generator:
   driver: bridge
   ipam:
     config:
       - subnet: 192.168.168.0/24
" >$DIR/docker-compose-postgres.yml

echo "2 - Run postgres"
docker-compose -f $DIR/docker-compose-postgres.yml up -d

echo "
Credentials:
                user: myuser
                password: myuserpassword
                db: mydb
                port: 5432

command : psql -h <ip> -U myuser mydb

"
}

mariadb() {

echo
echo "Install Mariadb"

echo "1 - Create directories ${DIR}/generator/mariadb/"
mkdir -p $DIR/mariadb/
chmod 775 -R $DIR/mariadb/

echo "2 - Create docker-compose file"
echo "
version: '3'
services:
  mariadb:
    container_name: mariadb
    image: mariadb/server:latest
    volumes:
     - mariadb_data:/var/lib/mysql/
    environment:
      MYSQL_ROOT_PASSWORD: myrootpassword
      MYSQL_DATABASE: mydatabase
      MYSQL_USER: myuser
      MYSQL_PASSWORD: myuserpassword
    ports:
    - 3306:3306
    networks:
    - generator
volumes:
  mariadb_data:
    driver: local
    driver_opts:
      o: bind
      type: none
      device: ${DIR}/mariadb/
networks:
  generator:
   driver: bridge
   ipam:
     config:
       - subnet: 192.168.168.0/24
" >$DIR/composefile/docker-compose-mariadb.yml

echo "3 - Run mariadb"
docker-compose -f $DIR/composefile/docker-compose-mariadb.yml up -d

echo "4 - Credentials"
echo "
      MYSQL_ROOT_PASSWORD: myrootpassword
      MYSQL_DATABASE: mydatabase
      MYSQL_USER: myuser
      MYSQL_PASSWORD: myuserpassword
"
}

prometheus() {
echo
echo "Install Prometheus"

echo "1 - Create directories ${DIR}/prometheus/{etc,data}"
mkdir -p $DIR/prometheus/{etc,data}
chmod 775 -R $DIR/prometheus/

echo "2 - Create config file prometheus.yml "
echo "
global:
  scrape_interval:     5s # By default, scrape targets every 15 seconds.
  evaluation_interval: 5s # By default, scrape targets every 15 seconds.
  # scrape_timeout is set to the global default (10s).

  # Attach these labels to any time series or alerts when communicating with
  # external systems (federation, remote storage, Alertmanager).
  external_labels:
    monitor: 'codelab-monitor'

# Load rules once and periodically evaluate them according to the global 'evaluation_interval'.
rule_files:
  # - "first.rules"
  # - "second.rules"

# A scrape configuration containing exactly one endpoint to scrape:
# Here it's Prometheus itself.
scrape_configs:
- job_name: 'node'
  static_configs:
  #- targets: ['172.37.1.1:9100']
" > $DIR/prometheus/etc/prometheus.yml


echo "3 - Create docker compose for prometheus "
echo "
version: '3'
services:
  prometheus:
    image: quay.io/prometheus/prometheus:v2.0.0
    container_name: prometheus
    volumes:
     - prometheus_etc:/etc/prometheus/
     - prometheus_data:/prometheus/
    command: '--config.file=/etc/prometheus/prometheus.yml --storage.tsdb.path=/prometheus'
    ports:
     - 9090:9090
    networks:
     - generator
volumes:
  prometheus_etc:
    driver: local
    driver_opts:
      o: bind
      type: none
      device: ${DIR}/prometheus/etc/
  prometheus_data:
    driver: local
    driver_opts:
      o: bind
      type: none
      device: ${DIR}/prometheus/data/
networks:
  generator:
   driver: bridge
   ipam:
     config:
       - subnet: 192.168.168.0/24
" > $DIR/docker-compose-prometheus.yml

echo "4 - Run prometheus "
docker-compose -f $DIR/docker-compose-prometheus.yml up -d

firefox 127.0.0.1:9090

}

grafana() {
echo
echo "Install Grafana"

echo "1 - Create directories ${DIR}/grafana/{etc,data}"
mkdir -p $DIR/grafana/{etc,data}
chmod 777 -R $DIR/grafana/

echo "2 - Create docker compose for grafana"

echo "
version: '3'
services:
  grafana:
    image: grafana/grafana
    container_name: grafana
    user: 0:0
    ports:
      - 3000:3000
    volumes:
      - grafana_data:/var/lib/grafana/
      - grafana_etc:/etc/grafana/provisioning/
    networks:
      - generator
volumes:
  grafana_etc:
    driver: local
    driver_opts:
      o: bind
      type: none
      device: /home/maxence/Docker/generator/grafana/etc/
  grafana_data:
    driver: local
    driver_opts:
      o: bind
      type: none
      device: /home/maxence/Docker/generator/grafana/data/
networks:
  generator:
    driver: bridge
    ipam:
      config:
        - subnet: 192.168.168.0/24
" > $DIR/docker-compose-grafana.yml

echo "3 - Run grafana "
docker-compose -f $DIR/docker-compose-grafana.yml up -d
sleep 10s

echo "4 - Auto setup for local prometheus"
curl --user admin:admin "http://localhost:3000/api/datasources" -X POST -H 'Content-Type: application/json;charset=UTF-8' --data-binary '{"name":"test","isDefault":true ,"type":"prometheus","url":"http://localhost:9090","access":"proxy","basicAuth":false}'

firefox -p test 127.0.0.1:3000

}

mosquitto() {
echo
echo "Install Mosquitto"

echo "1 - Create directories ${DIR}/mosquitto/{config,data,log}"
mkdir -p $DIR/mosquitto/{config,data,log}

echo "2 - Copy the mosquitto config save"
cp -rT $DIR/save/mosquitto/mosquitto_conf_backup $DIR/mosquitto/config

echo "3 - Modify the permission right"
chmod 777 -R $DIR/mosquitto/

echo "4 - Create Dockerfile for mosquitto"
echo "FROM eclipse-mosquitto:2.0.15-openssl

" >$DIR/mosquitto/Dockerfile-mosquitto

echo "5 - Create docker compose for mosquitto "
echo "
version: '3'

services:
  mqtt:
    container_name: mosquitto
    build:
      context: .
      dockerfile: Dockerfile-mosquitto
    user: 1883:1883
    environment:
      - PUID=1883
      - PGID=1883
    image: eclipse-mosquitto:2.0.15-openssl
    restart: always
    ports:
      - "1883:1883"
      - "9001:9001"
    volumes:
      - mosquitto_conf:/mosquitto/config
      - mosquitto_data:/mosquitto/data:ro
      - mosquitto_log:/mosquitto/log

volumes:
  # config:
  # data:
  # log:
  mosquitto_conf:
    driver: local
    driver_opts:
      o: bind
      type: none
      device: ${DIR}/mosquitto/config
  mosquitto_data:
    driver: local
    driver_opts:
      o: bind
      type: none
      device: ${DIR}/mosquitto/data
  mosquitto_log:
    driver: local
    driver_opts:
      o: bind
      type: none
      device: ${DIR}/mosquitto/log
" > $DIR/composefile/docker-compose-mosquitto.yml

echo "6 - Run mosquitto "
docker-compose -f $DIR/composefile/docker-compose-mosquitto.yml up -d

echo "7 - Create a mosquitto username-password file
put the file in the save directory for mosquitto
cd $DIR/save/mosquitto/mosquitto_conf_backup
Command to enter in the container:
docker exec -it mosquitto sh
Command to create a new user-password pair:
mosquitto_passwd -c /mosquitto/config/mosquitto.passwd (username)
Command to quit te container:
exit"

}

portainer(){

echo
echo "Install Portainer"

echo "1 - Create directories ${DIR}/portainer/"
mkdir -p $DIR/portainer/

#potentiel problème avec la socket Docker
echo "2 - Create docker compose for portainer"
echo "
version: '3'

services:
##Portainer
  portainer:
    container_name: portainer
    image: portainer/portainer-ce
    restart: always
    ports:
      - "9010:9000"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    networks:
     - generator

networks:
  generator:
    driver: bridge
    ipam:
      config:
        - subnet: 192.168.168.0/24
" >$DIR/composefile/docker-compose-portainer.yml

echo "3 - Run portainer"
docker-compose -f $DIR/composefile/docker-compose-portainer.yml up -d

}

source datakeeper/minecraft.env

minecraft() {

echo
echo "Install Minecraft"

echo "1 - Create directories ${DIR}/minecraft/{plugin,mode}"
mkdir -p $DIR/minecraft/{plugin,mode,world}

echo "2 - Create volumes minecraftdata"
docker volume create minecraftdata

echo "2.5 - Copy the minecraft save"
cp -rT $DIR/save/minecraft $DIR/minecraft/world

echo "3 - Create docker compose for minecraft"
echo "
version: '3.8'

services:
  minecraft:
    image: itzg/minecraft-server
    container_name: minecraft_itgz
    volumes:
    - minecraftdata:/data
    - /home/minecraft/plugin:/plugins
    ports:
      - $MINECRAFT_PORT:25565
    environment:
      EULA: 'TRUE'
      TYPES: 'BUKKIT'
      MAX_MEMORY: '1G'
      OPS: $OPS
      MOTD: \"C'EST LA PETITE MAISON DANS LA PRAIRIE\\\\C'EST FAUX, C'EST l'APOCALYPSE\"
      DIFFICULTY: 'normal'
      ICON: 'https://animotaku.fr/wp-content/uploads/2023/03/anime-Shingeki-no-Kyojin-Saison-Finale-partie-2-visuel-1.jpeg'
      ENABLES_WHITELIST: 'TRUE'
      ENFORCE_WHITELIST: 'TRUE'
      ENABLE_RCON: 'true'
      RCON_PASSWORD: $RCON_PASSWORD
      RCON_PORT: $RCON_PORT
      #WORLD: https://www.minecraftmaps.com/survival-maps/cube-survival/download
    tty: true
    stdin_open: true
    restart: unless-stopped
  # rcon:
  #   image: itzg/rcon
  #   ports:
  #     - "4326:4326"
  #     - "4327:4327"
  #   volumes:
  #     - "rcon:/opt/rcon-web-admin/db"

volumes:
  minecraftdata:
    driver: local
    driver_opts:
      o: bind
      type: none
      device: ${DIR}/minecraft/world
  rcon:
" >$DIR/composefile/docker-compose-minecraft.yml

echo "4 - Run minecraft"
docker-compose -f $DIR/composefile/docker-compose-minecraft.yml up -d


}

source datakeeper/Webapp.env

Webapp() {

echo
echo "Install Webapplication"

echo "2 - Create directories for webapp ${DIR}/web-application/{www,Dockerfile}"
mkdir -p $DIR/web-application/{www,Dockerfile}
# chmod 775 -R $DIR/web-application/

echo "2 - Create directories for nginx ${DIR}/web-application/nginx/{config,log}"
mkdir -p $DIR/web-application/nginx/{config,log}
# chmod 775 -R $DIR/nginx/

echo "2 - Copy the nginx website and config save"
cp -rT $DIR/save/webapplication/webapp_www_backup $DIR/web-application/www
cp -rT $DIR/save/webapplication/webapp_nginx_conf_backup $DIR/web-application/nginx/config

echo "3 - Create Dockerfile for nginx"
echo "FROM nginx:latest

#COPY ./www/portfolio/ /var/www/portfolio/
# COPY ./www/seconde/ /var/www/seconde/

#COPY ./archi.conf /etc/nginx/conf.d/
# COPY ./seconde.conf /etc/nginx/conf.d/.
" >$DIR/web-application/Dockerfile/Dockerfile-nginx

# echo "4 - Create Dockerfile for php"
# echo "FROM php:fpm
# RUN apt-get update && apt-get install -y libmemcached-dev libssl-dev zlib1g-dev \
# 	&& pecl install memcached-3.2.0 \
# 	&& docker-php-ext-enable memcached
# CMD [\"php\", \"-S\", \"0.0.0.0:9000\"]
# " >$DIR/web-application/Dockerfile/Dockerfile-php

echo "5 - Create docker compose for web-application"
echo "
version: '3.0'

services:
  nginx:
    restart: always
    build:
      context: ./../web-application/Dockerfile/
      dockerfile: Dockerfile-nginx
    container_name: webapplication-EngineX
    ports:
      - $NGINX_PORT:80
    volumes:
      - website:/usr/share/nginx/html
      - nginx_conf:/etc/nginx/conf.d
    networks:
     - generator

  php:
    image: php:fpm
    restart: always
    # build:
    #   context: ./../web-application/Dockerfile/
    #   dockerfile: Dockerfile-php
    container_name: webapplication-php
    # stdin_open: true
    # tty: true
    ports:
      - $PHP_PORT:9000
    networks:
     - generator
    volumes:
      - website:/usr/share/nginx/html

volumes:
  website:
    driver: local
    driver_opts:
      o: bind
      type: none
      device: ${DIR}/web-application/www

  nginx_conf:
    driver: local
    driver_opts:
      o: bind
      type: none
      device: ${DIR}/web-application/nginx/config

networks:
  generator:
    driver: bridge
    ipam:
      config:
        - subnet: 192.168.168.0/24
" >$DIR/composefile/docker-compose-webapplication.yml

echo "6 - Run webapp"
docker-compose -f $DIR/composefile/docker-compose-webapplication.yml up -d #$DIR/composefile/docker-compose-nginx.yml up -d

}

source datakeeper/SQLDatabase.env

SQLDatabase(){
echo
echo "Install SQLDatabase"

echo "2 - Create directories for SQLDB ${DIR}/SQL-Database/data"
mkdir -p $DIR/SQL-Database/data

echo "3 - Create docker compose for web-application"
echo "
version: '3.0'
services:
  mariadb:
    restart: always
    image: mariadb/server:latest
    container_name: SQLdatabase-mariadb
    volumes:
     - mariadb_data:/var/lib/mysql/
    environment:
      MYSQL_ROOT_PASSWORD: $MYSQL_ROOT_PASSWORD
      MYSQL_DATABASE: $MYSQL_DATABASE
      MYSQL_USER: $MYSQL_USER
      MYSQL_PASSWORD: $MYSQL_PASSWORD
    ports:
    - $MARIADB_PORT:3306
    networks:
    - generator

  phpmyadmin:
    image: phpmyadmin
    restart: always
    container_name: SQLdatabase-phpmyadmin
    ports:
      - $PHPMYADMIN_PORT:80
    environment:
      - PMA_ARBITRARY=1
    networks:
    - generator

volumes:
  mariadb_data:
    driver: local
    driver_opts:
      o: bind
      type: none
      device: ${DIR}/SQL-Database/data

networks:
  generator:
    driver: bridge
    ipam:
      config:
        - subnet: 192.168.168.0/24
" >$DIR/composefile/docker-compose-SQLDatabase.yml

echo "4 - Run SQL-Database"
docker-compose -f $DIR/composefile/docker-compose-SQLDatabase.yml up -d
}
# Let's Go !! parse args  ####################################################################

parse_options $@

ip
