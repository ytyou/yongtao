#!/bin/bash

SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && /bin/pwd )"

. $SRC_DIR/utils.sh

read_configs $SRC_DIR/log_cleaner.conf

for logs in "${!configs[@]}"; do
    COUNT=0
    OPTS="-1v"

    RET=${configs[$logs]}
    if [[ $RET == -* ]]; then
        OPTS="-1rv"
        RET=${RET:1}
    fi

    for log in `ls $OPTS $logs`; do
        (( COUNT++ ))
        if [ $COUNT -gt $(( $RET )) ]; then
            run_as_root "$RM -f $log"
        fi
    done
done
