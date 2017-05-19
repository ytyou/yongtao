CP=/bin/cp
ECHO=/bin/echo
GREP=/bin/grep
LS=/bin/ls
MKDIR=/bin/mkdir
READLINK=/bin/readlink
REALPATH=/usr/bin/realpath
RM=/bin/rm
SED=/bin/sed
SH=/bin/sh
SUDO=/usr/bin/sudo
TEST=/usr/bin/test

DRY_RUN=false
STEP=0


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

function next_step()
{
    (( STEP++ ))
    $ECHO "STEP $STEP: $1"
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
