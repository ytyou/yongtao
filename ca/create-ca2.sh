#!/bin/bash

if [ ! -f /etc/ssl/certs/cacert.pem ]; then
    # Create a self-signed root certificate
    openssl req -new -x509 -extensions v3_ca -keyout cakey.pem -out cacert.pem -days 3650

    # Install the self-signed root certificate
    sudo mv cakey.pem /etc/ssl/private/
    sudo mv cacert.pem /etc/ssl/certs/
else
    echo "CA (/etc/ssl/certs/cacert.pem) already exist. Will not re-create."
fi

echo
echo "CA is ready to be used to sign certificates."
echo "To create and then sign certificate, run create-cert.sh."

exit 0
