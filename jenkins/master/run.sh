#!/bin/bash

DOCKER_SOCKET=/var/run/docker.sock
DOCKER_GROUP=dockerhost
JENKINS_USER=jenkins

if [ -S ${DOCKER_SOCKET} ]; then
DOCKER_GID=$(stat -c '%g' ${DOCKER_SOCKET})
groupadd -for -g ${DOCKER_GID} ${DOCKER_GROUP}
usermod -aG ${DOCKER_GROUP} ${JENKINS_USER}
fi

exec sudo /opt/sonar/bin/linux-x86-64/sonar.sh start &
exec sudo -E -H -u jenkins bash -c /usr/local/bin/jenkins.sh