#!/bin/bash

# To start grokdebug container for the first time
#docker run -d --name grokd -p 80:80 fdrouet/grokdebug:v1

# To wake up grokdebug container

ID=$(docker ps -f name=grokd -q)

if [ "_$ID" == "_" ]; then
    docker restart grokd
else
    echo "Grokd is already running. Do nothing."
fi

exit 0
