To create a Certificate Authority (CA),

1. Run create-ca1.sh;
2. Manually edit /etc/ssl/openssl.cnf according to instructions provided by the script;
3. Run create-ca2.sh;
   Country Name: CN
   State or Province Name:
   Locality Name: Beijing
   Organization Name: Cloudwiz
   Organizational Unit Name:
   Common Name: cloudwiz.cn
   Email Address: <user.name>@cloudwiz.cn

To create and sign a certificate using the CA created above,

1. Run create-cert.sh;
   Enter pass phrase for server.key: <password of private key of the cert>
   Verifying - Enter pass phrase for server.key: <password for private key of the cert>
   <All fields must match those of CA>
   Common Name: nginx.cloudwiz.cn
   A challenge password: <Do NOT enter any password; just RETURN>
   Enter pass phrase for /etc/ssl/private/cakey.pem: <this is the password of CA>

2. Collect the cert from stdout according to instructions provided by the script;
