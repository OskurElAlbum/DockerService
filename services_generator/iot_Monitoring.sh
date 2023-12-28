#!/bin/bash

DIR="${HOME}/Documents/Docker/Dockerservice"
DIR_IOT_MONITORING="${DIR}/services/iot_Monitoring"
USER_SCRIPT=$USER

# Fonctions ###########################################################

echo "1 - Create directories for Mosquitto ${DIR_IOT_MONITORING}/mosquitto/{config,data,log}"
mkdir -p ${DIR_IOT_MONITORING}/mosquitto/{config,data,log}

echo "2 - Create directories for Python ${DIR_IOT_MONITORING}/python/{file,DockerFile}"
mkdir -p ${DIR_IOT_MONITORING}/python/{file,DockerFile}

echo "2 - Create directories for SQL Database ${DIR_IOT_MONITORING}/mariadb/{data,entrypoint,DockerFile}"
mkdir -p ${DIR_IOT_MONITORING}/mariadb/{data,entrypoint,DockerFile}

echo "3 - Create directories for grafana ${DIR_IOT_MONITORING}/grafana/{etc,data}"
mkdir -p ${DIR_IOT_MONITORING}/grafana/{etc,data}

echo "4 - Copy the environment variable, and saved file"
cp ${DIR}/save/iot_Monitoring/.env ${DIR_IOT_MONITORING}
cp -rT ${DIR}/save/iot_Monitoring/mosquitto ${DIR_IOT_MONITORING}/mosquitto/config
cp -rT ${DIR}/save/iot_Monitoring/python/file ${DIR_IOT_MONITORING}/python/file
cp -rT ${DIR}/save/iot_Monitoring/python/DockerFile ${DIR_IOT_MONITORING}/python/DockerFile
cp -rT ${DIR}/save/iot_Monitoring/mariaDB ${DIR_IOT_MONITORING}/mariadb/entrypoint
cp -rT ${DIR}/save/iot_Monitoring/mariaDB ${DIR_IOT_MONITORING}/mariadb/DockerFile
sudo chmod -R 777 ${DIR_IOT_MONITORING}/mosquitto

echo "5 - Create docker compose for Iot Monitoring services"
echo "
version: '3.0'

services:
  Iot_Monitoring_Mosquitto:
    image: eclipse-mosquitto:openssl
    container_name: Iot_Monitoring_Mosquitto
    restart: always
    env_file: .env
    ports:
    - \"\${MOSQUITTO_PORT}:1883\"
    - \"\${MOSQUITTO_WEBSOCKET_PORT}:9001\"
    volumes:
     - Iot_Monitoring_Mosquitto_Conf:/mosquitto/config
     - Iot_Monitoring_Mosquitto_Data:/mosquitto/data:ro
     - Iot_Monitoring_Mosquitto_Log:/mosquitto/log
    networks:
    - Iot_Monitoring_network

  iot_monitoring_python:
#    image: python:3.9
    container_name: iot_monitoring_python
#    restart: always
    build:
      context: ./python/file/
    volumes:
      - Iot_Monitoring_Python_File:/app
    environment:
      PYTHON_MQTT_BROKER: Iot_Monitoring_Mosquitto
      PYTHON_MQTT_PORT: 1883
      PYTHON_MQTT_TOPIC: \"\$MOSQUITTO_TOPIC\"
      PYTHON_MQTT_USERNAME: \"\$MOSQUITTO_USERNAME\"
      PYTHON_MQTT_PASSWORD: \"\$MOSQUITTO_PASSWORD\"
      PYTHON_DB_HOST: Iot_Monitoring_Mariadb
      PYTHON_DB_USER: \"\$MYSQL_USER\"
      PYTHON_DB_PASSWORD: \"\$MYSQL_PASSWORD\"
      PYTHON_DB_DATABASE: \"\$MYSQL_DATABASE\"
    networks:
      - Iot_Monitoring_network
    depends_on:
    - Iot_Monitoring_Mosquitto
    - Iot_Monitoring_Mariadb

  Iot_Monitoring_Mariadb:
    image: mariadb:latest
    container_name: Iot_Monitoring_Mariadb
    restart: always
    build:
      context: ./mariadb/DockerFile
    env_file: .env
    ports:
    - \"\${MARIADB_PORT}:3306\"
    volumes:
     - Iot_Monitoring_Mariadb_Data:/var/lib/mysql/
     - Iot_Monitoring_Mariadb_Entrypoint:/docker-entrypoint-initdb.d
    environment:
      MYSQL_ROOT_PASSWORD: \"\$MYSQL_ROOT_PASSWORD\"
      MYSQL_DATABASE: \"\$MYSQL_DATABASE\"
      MYSQL_USER: \"\$MYSQL_USER\"
      MYSQL_PASSWORD: \"\$MYSQL_PASSWORD\"
    networks:
    - Iot_Monitoring_network

  Iot_Monitoring_Grafana:
    image: grafana/grafana:latest
    container_name: Iot_Monitoring_Grafana
    restart: always
    env_file: .env
    ports:
    - \"\${GRAFANA_PORT}:3000\"
    volumes:
      - Iot_Monitoring_Grafana_Data:/var/lib/grafana/
      - Iot_Monitoring_Grafana_Etc:/etc/grafana/provisioning/
    user: 0:0
    networks:
      - Iot_Monitoring_network

volumes:
  Iot_Monitoring_Mosquitto_Conf:
    driver: local
    driver_opts:
      o: bind
      type: none
      device: ${DIR_IOT_MONITORING}/mosquitto/config
  Iot_Monitoring_Mosquitto_Data:
    driver: local
    driver_opts:
      o: bind
      type: none
      device: ${DIR_IOT_MONITORING}/mosquitto/data
  Iot_Monitoring_Mosquitto_Log:
    driver: local
    driver_opts:
      o: bind
      type: none
      device: ${DIR_IOT_MONITORING}/mosquitto/log

  Iot_Monitoring_Python_File:
      driver: local
      driver_opts:
        o: bind
        type: none
        device: ${DIR_IOT_MONITORING}/python/file

  Iot_Monitoring_Mariadb_Data:
      driver: local
      driver_opts:
        o: bind
        type: none
        device: ${DIR_IOT_MONITORING}/mariadb/data
  Iot_Monitoring_Mariadb_Entrypoint:
        driver: local
        driver_opts:
          o: bind
          type: none
          device: ${DIR_IOT_MONITORING}/mariadb/entrypoint

  Iot_Monitoring_Grafana_Etc:
    driver: local
    driver_opts:
      o: bind
      type: none
      device: ${DIR_IOT_MONITORING}/grafana/etc/
  Iot_Monitoring_Grafana_Data:
    driver: local
    driver_opts:
      o: bind
      type: none
      device: ${DIR_IOT_MONITORING}/grafana/data/

networks:
  Iot_Monitoring_network:
    driver: bridge
    ipam:
      config:
        - subnet: 192.168.170.0/24
" >${DIR_IOT_MONITORING}/docker-compose.yml

echo "6 - Run Iot Monitoring services"
cd ${DIR_IOT_MONITORING}
docker-compose build --no-cache
docker-compose -f ${DIR_IOT_MONITORING}/docker-compose.yml up -d

#echo "7 - Create a mosquitto username-password file
#put the file in the save directory for mosquitto
#cd $DIR/save/mosquitto/mosquitto_conf_backup
#Command to enter in the container:
#docker exec -it Iot_Monitoring_Mosquitto sh
#Command to create a new user-password pair:
#mosquitto_passwd -c /mosquitto/config/mosquitto.passwd (username)
#Command to quit te container:
#exit"