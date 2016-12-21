#!/bin/bash

sudo mkdir -p /etc/ssl/CA
sudo mkdir -p /etc/ssl/newcerts

if [ ! -f /etc/ssl/CA/serial ]; then
    sudo sh -c "echo '01' > /etc/ssl/CA/serial"
fi

if [ ! -f /etc/ssl/CA/index.txt ]; then
    sudo touch /etc/ssl/CA/index.txt
fi

echo "Edit [CA_default] section in /etc/ssl/openssl.cnf as follows:"
echo
echo "dir           = /etc/ssl"
echo "database      = \$dir/CA/index.txt"
echo "certificate   = \$dir/certs/cacert.pem"
echo "serial        = \$dir/CA/serial"
echo "private_key   = \$dir/private/cakey.pem"
echo
echo "Then run create-ca2.sh to finish creating CA."

exit 0
