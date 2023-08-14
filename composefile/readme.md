# The dockercompose file are storage in this directory

Directory where are located the dockercompose file generate by the generator.sh file.

## this is an example of a docker compose file used to create a jenkins services
''' dockercompose
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
volumes:
  jenkins_data:
    driver: local
    driver_opts:
      o: bind
      type: none
      device: ${DIR}/jenkins/
'''