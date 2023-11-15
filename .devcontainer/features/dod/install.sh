#!/bin/sh

set -e

echo "Activating feature 'alpine-docker'"

apk add --no-cache docker

CURRENT_USER=$(awk -v val=1000 -F ":" '$3==val{print $1}' /etc/passwd)
echo "CURRENT_USER is $CURRENT_USER"

echo "HOST_DOCKER_GID is $HOSTDOCKERGID"

HOST_DOCKER_GROUP=$(getent group $HOSTDOCKERGID | cut -d: -f1)
echo "HOST_DOCKER_GROUP from id is $HOST_DOCKER_GROUP"

if [[ -z $HOST_DOCKER_GROUP ]]; then
    addgroup -g $HOSTDOCKERGID host-docker
    HOST_DOCKER_GROUP=host-docker
fi

addgroup $CURRENT_USER $HOST_DOCKER_GROUP

if [[ $INSTALLDOCKERCOMPOSE == "true" ]]; then
    apk add --no-cache docker-compose
fi

echo 'Done!'