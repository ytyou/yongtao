#!/bin/bash

log_dir="/data/log/nginx"
current_date=$(date "+%Y.%m.%d")

mv $log_dir/access.log $log_dir/access.log.$current_date
mv $log_dir/error.log $log_dir/error.log.$current_date

kill -USR1 `cat /opt/nginx/logs/nginx.pid`

for i in $(seq 10 20); do
    other_date=$(date --date="$i days ago" "+%Y.%m.%d")
    rm -f $log_dir/access.log.$other_date
    rm -f $log_dir/error.log.$other_date
done
