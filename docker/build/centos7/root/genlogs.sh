#!/bin/bash

#DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

#source $DIR/startsvc.sh

# Generate log into /var/log/test.log

LOGFILE=/var/log/test/test.log

MARKER='@#CWIZ#@'
TYPES=("counter" "gauge" "latency")
METRICS=("cpu" "disk" "memory" "network")
TAGNAMES=("tag1" "tag2" "tag3" "tag4" "tag5" "tag6")
TAGVALUES=("value1" "warning" "error" "exception")

while true
do
    # generate metric info
    id=$(openssl rand -base64 32 | head -c 16)
    metrictype=${TYPES[$RANDOM % ${#TYPES[@]}]}
    timestamp=$(date +%s)
    metric=${METRICS[$RANDOM % ${#METRICS[@]}]}
    value=$(shuf -i 1-1000 -n 1)

    # generate tags
    unset tags
    declare -A tags

    let cnt=(RANDOM % ${#TAGVALUES[@]})+1
    while ((cnt > 0))
    do
        tag=${TAGNAMES[$RANDOM % ${#TAGNAMES[@]}]}
        val=${TAGVALUES[$RANDOM % ${#TAGVALUES[@]}]}
        tags[$tag]=$val
        ((cnt--))
    done
    log=${LOGFILE}.`date +%Y-%m-%d`
    echo -n "${MARKER} $id ${metrictype} ${timestamp} ${metric} ${value}" >> $log
    for tag in ${!tags[@]}; do
        echo -n " ${tag}=${tags[${tag}]}" >> $log
    done
    echo >> $log

    sleep 60
done
