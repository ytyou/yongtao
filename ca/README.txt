To create a Certificate Authority (CA),

1. Run create-ca1.sh;
2. Manually edit /etc/ssl/openssl.cnf according to instructions provided by the script;
3. Run create-ca2.sh;

To create and sign a certificate using the CA created above,

1. Run create-cert.sh;
2. Collect the cert from stdout according to instructions provided by the script;
