#!/bin/bash

DIR="${HOME}/Documents/Docker/Dockerservice"
DIR_MINECRAFT="${DIR}/services/minecraft"
USER_SCRIPT=$USER

# Fonctions ###########################################################

echo "1 - Create directories ${DIR_MINECRAFT}/{plugin,mode,world}"
mkdir -p $DIR_MINECRAFT/{plugin,mode,world}

echo "2 - Copy the environment variable and the saved file"
cp -rT $DIR/save/minecraft $DIR_MINECRAFT

echo "3 - Create volumes minecraftdata"
docker volume create minecraftdata

echo "3.5 - Copy the minecraft save"
cp -rT $DIR/save/minecraft $DIR_MINECRAFT/world

echo "4 - Create docker compose for minecraft"
echo "
version: '3.8'

services:
  minecraft:
    image: itzg/minecraft-server
    container_name: minecraft_itgz
    restart: always
    env_file: .env
    ports:
      - \"\${MINECRAFT_PORT}:25565\"
    volumes:
    - minecraftdata:/data
    environment:
      EULA: 'TRUE'
      MAX_MEMORY: '1G'
      OPS: \$MINECRAFT_OPS
      MOTD: \"\$MINECRAFT_PRESENTATION\"
      DIFFICULTY: 'normal'
      ICON: '\$MINECRAFT_IMAGE'
      ENABLES_WHITELIST: 'true'
      ENABLE_RCON: 'true'
      RCON_PASSWORD: \$MINECRAFT_RCON_PORT
      RCON_PORT: \$MINECRAFT_RCON_PASSWORD
    tty: true
    stdin_open: true

volumes:
  minecraftdata:
    driver: local
    driver_opts:
      o: bind
      type: none
      device: $DIR_MINECRAFT/world

" >$DIR_MINECRAFT/docker-compose-minecraft.yml

echo "5 - Run minecraft"
docker-compose -f $DIR_MINECRAFT/docker-compose-minecraft.yml up -d