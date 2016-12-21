#!/bin/bash

name="server"

if [ $# = 1 ]; then
    name=$1
fi

echo "Creating a signed certificate: $name"

# generate key
openssl genrsa -des3 -out $name.key 2048

# convert key to pkcs8 format
openssl pkcs8 -topk8 -inform pem -in $name.key -outform pem -nocrypt -out $name.pem

# generate insecure key out of secure key
openssl rsa -in $name.pem -out $name.key.insecure

# convert insecure key to pkcs8 format
openssl pkcs8 -topk8 -inform pem -in $name.key.insecure -outform pem -nocrypt -out $name.pem.insecure

# rename keys
mv $name.pem $name.pem.secure
mv $name.pem.insecure $name.pem

# create CSR for signing
tput setaf 1
echo "Use 'CloudWiz' as 'Organization Name'"
echo "Use nginx host DNS or IP as 'Common Name'"
tput sgr0
openssl req -new -key $name.pem -out $name.csr

# sign the certificate
sudo openssl ca -in $name.csr -config /etc/ssl/openssl.cnf

echo
echo "Copy and paste the following section to a file $name.crt:
-----BEGIN CERTIFICATE-----
... ...
----END CERTIFICATE-----
"

exit 0
