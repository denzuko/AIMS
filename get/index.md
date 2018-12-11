#!/usr/bin/env bash
export RHOST=localhost
[ -f $HOME/.id_rsa ] || ssh-keygen
eval $(ssh-agent) && ssh-add
ssh-copy-id $RHOST 
docker-machine -d generic --generic-ip-address=$RHOST create aims && eval $(docker-machine env aims)
docker swarm init
git clone https://github.com/denzuko/AIMS.git aims && cd $_
docker swarm deploy -c docker-compose.yml
