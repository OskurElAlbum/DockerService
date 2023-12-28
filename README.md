# This is multiservice docker creator

## Currently work to install:
- container monitoring service
- Minecraft server
- SQL Database and monitoring service
- Web application service
- CCTV server

## Need to be installed
- IOT monittoring service

## To setup
- Backup setup
- Retrieving save directory files from a remote repository 

## Each directory has the following goal:
**services** : Directory where are located all file used by each services
**services_generator** : Directory where are located the shell script use to build each services   
**save** : Directory where are located the configuration and fonctionnal file of each services (To be added by the user) 
e.g. the file used by your website    
**backup** : WIP (Directory where are located file recover for each services)  

# How to use the project
To use this projet, execute in first the **installation.sh** file, who download on your machine docker and docker compose.

<!-- The permission right must maybe modified to execute shell file, if it is needed use the command:
```chmod 755 filetomodifie.sh``` -->

<!-- ## network_creator.sh
This file allow you to create some docker network, to create one, you need to you the following syntax :
```./network_creator.sh network_to_be_created``` -->

## generator.sh
This file allow you to generate different service containerize with docker, to create one of them, , you need to you the following syntax :
```bash
./generator.sh -service_to_be_created
```

To know what is the command to use each services, you can refer to help using the command : 
```bash
./generator.sh -h
```