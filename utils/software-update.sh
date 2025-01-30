#!/bin/bash

HOSTS=()
SHELL=/bin/bash
UPDATE_TT=1

log() {
    H=$1
    M=$2
    TS=$(date +"%Y-%m-%d %H:%M:%S")
    echo "[$TS] [$H] $M"
}

start_host() {

    log $1 "Starting VM $1"
    STATUS=0

    # start the VM, if not already started
    tmp=$(virsh list --all | grep " $1 " | awk '{ print $3}')

    if ([ "x$tmp" == "x" ] || [ "x$tmp" != "xrunning" ]); then
        log $1 "Start VM $1"
        virsh start $1
        if [[ $? -ne 0 ]]; then
            return 2
        else
            STATUS=1
        fi
    else
        log $1 "VM $1 is already started"
    fi

    # wait for the VM to become available
    for i in {1..30}; do
        nmap -p 22 $1 --open | grep '22/tcp open  ssh' > /dev/null
        if [[ $? -eq 0 ]]; then
            break
        fi
        sleep 1
    done

    nmap -p 22 $1 --open | grep '22/tcp open  ssh' > /dev/null
    if [[ $? -ne 0 ]]; then
        return 2
    else
        sleep 2
        log $1 "VM $1 is available"
    fi

    return $STATUS
}

stop_host() {
    log $1 "Stopping VM $1"
    virsh shutdown $1
    return $?
}

update_host() {
    H=$1

    # try apt-get
    ssh -t $H 'which apt-get &> /dev/null'
    if [[ $? -eq 0 ]]; then
        ssh -t $H 'sudo apt-get -y update; sudo apt-get -y upgrade; sudo apt -y autoremove'
        return 0
    fi

    # try yum
    ssh -t $H 'which yum &> /dev/null'
    if [[ $? -eq 0 ]]; then
        ssh -t $H 'sudo yum -y update; sudo yum -y upgrade'
        return 0
    fi

    # try zypper
    ssh -t $H 'which zypper &> /dev/null'
    if [[ $? -eq 0 ]]; then
        ssh -t $H 'sudo zypper -n update -y'
        return 0
    fi
}


# process cmdline options
while [[ $# -gt 0 ]]
do
    key=$1

    case $key in
        -all)
        HOSTS=(`virsh list --all --name`)
        ;;

        -tt)
        UPDATE_TT=0
        ;;

        -h)
        echo "Usage: $0 [-h] [-tt (skip tt)] [-all'] [<vms>]"
        exit 0
        ;;
    
        -?)
        echo "Usage: $0 [-h] [-tt (skip tt)] [-all'] [<vms>]"
        exit 0
        ;;

        *)
        HOSTS+=("$1") 
        ;;
    esac
    shift
done

if [ ${#HOSTS[@]} -eq 0 ] && [ $UPDATE_TT -eq 0 ]; then
    echo "Nothing to do. Exit!"
    exit 0
fi

if [ $UPDATE_TT -eq 1 ]; then
    HOST_CNT=${#HOSTS[@]}
    HOST_CNT=$((HOST_CNT+1))
    MSG="Updating & upgrading software on $HOST_CNT hosts: tt ${HOSTS[@]}"
else
    MSG="Updating & upgrading software on ${#HOSTS[@]} hosts: ${HOSTS[@]}"
fi
echo $MSG

# confirm
read -p "Continue? [y/n] " -n 1 -r
echo    
        
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo "Aborted!"
    rm -f $SELF_LOG
    exit 0
fi

# update tt
if [ $UPDATE_TT -eq 1 ]; then
    log "tt" "Updating..."
    sudo apt-get -y update
    log "tt" "Upgrading..."
    sudo apt-get -y upgrade
    echo
fi

# update hosts in HOSTS[]
for HOST in "${HOSTS[@]}"; do
    log $HOST "Starting..."
    start_host $HOST
    STATUS=$?

    log $HOST "Updating..."
    update_host $HOST

    if [ $STATUS -eq 1 ]; then
        log $HOST "Shutdown..."
        stop_host $HOST
    fi
done

exit 0
