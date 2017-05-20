#!/bin/bash

SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && /bin/pwd )"

. $SRC_DIR/utils.sh

read_configs $SRC_DIR/log_cleaner.conf

for logs in "${!configs[@]}"; do
    RET=${configs[$logs]}
    COUNT=0
    for log in `ls -1v $logs`; do
        (( COUNT++ ))
        if [ $COUNT -gt $(( $RET )) ]; then
            run_as_root "$RM -f $log"
        fi
    done
done
