#!/bin/bash

ID=$(docker ps -f name=grokd -q)

if [ "_$ID" == "_" ]; then
    echo "Grokd is not running. Do nothing."
else
    docker stop -t 2 grokd
fi

exit 0
