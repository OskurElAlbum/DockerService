#This is multiservice docker creator

##Currently work to install:
-container monitoring server
-Web server
-MQTT server
-Minecraft server
-SQL Database server

##Each directory has the following goal:
**composefile** : Directory where are located the docker compose file of each services
**save** : Directory where are located file used by each services to work correctly
e.g. the file used by your website
**datakeeper** : Directory where are located file used for identification on each services
**backup** : Directory where are located file recover for each services