docker run –rm –volumes-from minecraft_minecraft_1 -v /home/maxence/Docker/generator/backup/minecraft:/minecraft_minecraft_1 bash -c “cd /data && tar xvf minecraft_minecraft_1/minecraft_minecraftdata_2023-07-18_234137.tar –strip 1”
# Name of container
# Location of your backup file
# Name of your backup file
/home/maxence/Docker/generator/backup/minecraft/minecraft_minecraft_1/minecraft_minecraftdata_2023-07-18_234137.tar
