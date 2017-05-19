#!/bin/bash

# The directory where this script resides
SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && /bin/pwd )"

. $SRC_DIR/utils.sh

# Parse command line options, if any
OPTS=`getopt -o d --long dry-run -n 'setup_new_vm.sh' -- "$@"`
eval set -- "$OPTS"

while true
do
    case "$1" in
        -d|--dry-run)
            DRY_RUN=true ; shift ;;
        --) shift ; break ;;
        *) $ECHO "Unknown option!" ; exit 1 ;;
    esac
done

# Remove unused directories
next_step "Remove unused directories"
DIRS2RM=( ~/Music ~/Pictures ~/Public ~/Templates ~/Videos )
for d in "${DIRS2RM[@]}"
do
    rm_dir_if_empty $d
done

# Add shell alias
next_step "Add custom aliases"
[ -f ~/.bash_aliases ] && $GREP -q "alias cls=" ~/.bash_aliases
if [ $? -ne 0 ]; then
    dry_or_wet "$ECHO \"alias cls='/usr/bin/clear'\" >> ~/.bash_aliases"
fi

# Generate ~/.vimrc file
next_step "Generate ~/.vimrc file"
if [ ! -f ~/.vimrc ]; then
    dry_or_wet "$ECHO \"set tabstop=4\" >> ~/.vimrc"
    dry_or_wet "$ECHO \"set expandtab\" >> ~/.vimrc"
    dry_or_wet "$ECHO \"set nobackup\" >> ~/.vimrc"
    dry_or_wet "$ECHO \"set dir=/tmp\" >> ~/.vimrc"
    dry_or_wet "$ECHO \"set hlsearch\" >> ~/.vimrc"
fi

# Add time to shell prompt
next_step "Add [time] to shell prompt in ~/.bashrc"
[ -f ~/.bashrc ] && $GREP -q '\\u@\\h\[\\t\]' ~/.bashrc
if [ $? -ne 0 ]; then
    if [ ! -f ~/.bashrc.bak ]; then
        dry_or_wet "$CP -n ~/.bashrc ~/.bashrc.bak"
        dry_or_wet "$SED -i 's/\\\\u@\\\\h/\\\\u@\\\\h[\\\\t]/g' ~/.bashrc"
    else
        error_out "File ~/.bashrc.bak already exists. Won't make any changes to ~/.bashrc."
    fi
fi

# Setup NFS file sharing
next_step "Setup NFS file sharing at /var/share"
if [ ! -d /var/share ]; then
    dry_or_wet "$SUDO $MKDIR -p /var/share"
    dry_or_wet "$SUDO $SH -c \"$ECHO '172.16.16.1:/var/share /var/share nfs rw,user,auto 0 0' >> /etc/fstab\""
fi
