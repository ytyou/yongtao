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
dry_or_wet "$MKDIR -p $HOME/src"
find_in_file "alias cls=" ~/.bashrc
if [ $? -ne 0 ]; then
    dry_or_wet "$ECHO \"alias cls='/usr/bin/clear'\" >> ~/.bashrc"
    dry_or_wet "$ECHO \"alias src='cd ~/src'\" >> ~/.bashrc"
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
find_in_file 'PS1' ~/.bashrc
if [ $? -ne 0 ]; then
    if [ ! -f ~/.bashrc.bak ]; then
        dry_or_wet "$CP -n ~/.bashrc ~/.bashrc.bak"
        dry_or_wet "$ECHO \"export PS1=\\\"[\u@\h \t \W]\\$ \\\"\" >> ~/.bashrc"
    else
        error_out "File ~/.bashrc.bak already exists. Won't make any changes to ~/.bashrc."
    fi
fi

# Setup NFS file sharing
next_step "Setup NFS file sharing at /var/share"
if [ ! -d /var/share ]; then
    install_pkgs "nfs-utils nfs-utils-lib"
    run_as_root "$MKDIR -p /var/share"
    run_as_root "$ECHO '172.16.16.1:/var/share /var/share nfs rw,user,auto 0 0' >> /etc/fstab"
fi

# Open iptables firewall
next_step "Remove REJECT rules in iptables"
run_as_root "$SED -i 's/^-A INPUT -j REJECT/#-A INPUT -j REJECT/g' /etc/sysconfig/iptables"

# Enable SSHD
next_step "Enable SSHD"
run_as_root "$CHKCONFIG sshd on"

# Generate SSH key
next_step "Generate SSH key"
if [ ! -f ~/.ssh/id_rsa ]; then
    dry_or_wet "$SSH_KEYGEN -q -t rsa -f ~/.ssh/id_rsa -N ''"
fi

# Setup passwordless sudo privilege
next_step "Setup passwordless sudo privilege"
run_as_root "$SED -i 's/# %wheel	ALL=(ALL:ALL)	NOPASSWD/%wheel	ALL=(ALL:ALL)	NOPASSWD/' /etc/sudoers"

# Add yongtao to user group wheel
next_step "Add yongtao to user group wheel"
run_as_root "$USERMOD -aG wheel yongtao"

# Install commonly used packages
next_step "Install commonly used packages"
install_pkg "epel-release.noarch"
install_pkg "xclip"

# Potential packages to install
next_step "You might also be interested in installing the following packages:"
$ECHO "- Password Manager: sudo yum install passwordsafe"
