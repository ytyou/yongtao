#!/bin/bash

echo "172.17.0.2    centos1" >> /etc/hosts
echo "172.17.0.3    centos2" >> /etc/hosts
echo "172.17.0.4    centos3" >> /etc/hosts
echo "172.17.0.5    centos4" >> /etc/hosts
echo "172.17.0.6    centos5" >> /etc/hosts

rm -rf /run/nologin
/usr/bin/supervisord
