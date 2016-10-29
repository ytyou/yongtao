#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source $DIR/startsvc.sh

# Generate log into /var/log/test.log

LOGFILE=/var/log/test.log

while true
do
    timestamp=$(date)
    metric1=$(shuf -i 1-100 -n 1)
    metric2=$(shuf -i 1-10000 -n 1)
    tag1=$(date | md5sum | head -c 8)
    tag2=$(date | md5sum | head -c 8)
    echo "${timestamp} metric1=${metric1} metric2=${metric2} tag1=\"${tag1}\" tag2=\"${tag2}\"" >> $LOGFILE
    sleep 1
done
