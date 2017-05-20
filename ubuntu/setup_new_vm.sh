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
find_in_file "alias cls=" ~/.bash_aliases
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
find_in_file '\\u@\\h\[\\t\]' ~/.bashrc
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
    run_as_root "$MKDIR -p /var/share"
    run_as_root "$ECHO '172.16.16.1:/var/share /var/share nfs rw,user,auto 0 0' >> /etc/fstab"
fi

# Update network startup timeout
next_step "Reduce network startup timeout from 5min to 30sec"
run_as_root "$SED -i 's/TimeoutStartSec=5min/TimeoutStartSec=30sec/' /lib/systemd/system/networking.service"

# Update screen resolution
next_step "Increase screen resolution"
find_in_file "nomodeset" /etc/default/grub
if [ $? -ne 0 ]; then
    install_pkgs "xvfb xfonts-100dpi xfonts-75dpi xfstt"
    run_as_root "$ECHO 'GRUB_GFXMODE=1280x960,1280x800,1280x720,1152x768,1152x700,1024x768,800x600' >> /etc/default/grub"
    run_as_root "$ECHO 'GRUB_PAYLOAD_LINUX=keep' >> /etc/default/grub"
    run_as_root "$SED -i 's/GRUB_CMDLINE_LINUX_DEFAULT=\\\"\\\"/GRUB_CMDLINE_LINUX_DEFAULT=\\\"nomodeset\\\"/' /etc/default/grub"
    run_as_root "update-grub"
    $ECHO "Reboot required!"
fi

# Generate SSH key
next_step "Generate SSH key"
if [ ! -f ~/.ssh/id_rsa ]; then
    dry_or_wet "$SSH_KEYGEN -q -t rsa -f ~/.ssh/id_rsa -N ''"
fi

# Setup passwordless sudo privilege
next_step "Setup passwordless sudo privilege"
run_as_root "$SED -i 's/%sudo	ALL=(ALL:ALL) ALL/%sudo	ALL=(ALL:ALL) NOPASSWD: ALL/' /etc/sudoers"

# Install PasswordSafe
next_step "Install PasswordSafe"
install_pkg "passwordsafe"
