CHKCONFIG=/sbin/chkconfig
CP=/bin/cp
DPKG=/usr/bin/dpkg
ECHO=/bin/echo
GREP=/bin/grep
LS=/bin/ls
MKDIR=/bin/mkdir
PWD=/bin/pwd
READLINK=/bin/readlink
REALPATH=/usr/bin/realpath
RM=/bin/rm
SED=/bin/sed
SH=/bin/sh
SSH_KEYGEN=/usr/bin/ssh-keygen
SUDO=/usr/bin/sudo
TEST=/usr/bin/test
USERMOD=/usr/sbin/usermod
YUM=/usr/bin/yum

DRY_RUN=false
STEP=0

declare -A configs


function dry_or_wet()
{
    if $DRY_RUN ; then
        $ECHO "[DRY] $@"
    else
        eval "$@"
        if [ $? -ne 0 ]; then
            $ECHO "$@ failed, exiting..."
            exit 2
        else
            return $?
        fi
    fi
}

function error_out()
{
    $ECHO "[ERROR] $1 Exiting..."
    exit 3
}

function run_as_root()
{
    local CMD=$1

    if [ "_$USER" != "_root" ]; then
        CMD="$SUDO $SH -c \"$1\""
    fi

    dry_or_wet "$CMD"
}

function find_in_file()
{
    local PATTERN=$1
    local FILE=$2
    [ -f $FILE ] && $GREP -q "$PATTERN" $FILE
    return $?
}

function next_step()
{
    (( STEP++ ))
    $ECHO "STEP $STEP: $1"
}

function is_pkg_installed()
{
    $DPKG -l | $GREP "$1" | $GREP '^ii' > /dev/null
    return $?
}

function install_pkg()
{
    is_pkg_installed "$1"
    if [ $? -ne 0 ]; then
        run_as_root "$YUM install -y $1"
        return $?
    else
        return 0
    fi
}

function install_pkgs()
{
    run_as_root "$YUM install -y $@"
    return $?
}

# The config file should look like this:
# key1:value1
# key2:value2
# ...
# keyN:valueN
function read_configs()
{
    local OLD_IFS=$IFS
    IFS=":"
    while read -r name value
    do
        configs["$name"]="$value"
    done < $1
    IFS=$OLD_IFS
}

# Remove the directory if it's empty
function rm_dir_if_empty()
{
    if [ -d $1 ]; then
        if [ ! "$($LS -A $1)" ]; then
            dry_or_wet "$RM -rf $1"
        else
            $ECHO "Directory $1 not empty. It will not be removed."
        fi
    fi
}
