# Yii 1.1 Framework
#
# Build cos7-sysd-base first!
#
# To build:
#   1. Build cos7-sysd-base first;
#   2. Download https://github.com/yiisoft/yii/releases/download/1.1.24/yii-1.1.24.a5ab20.tar.gz into ./tmp/;
#   3. docker build --rm -t local/cos7-sysd-app .
#
# To run it (detached):
#   docker run -d -ti --name podbean --privileged -v /sys/fs/cgroup:/sys/fs/cgroup:ro -p 80:80 local/cos7-sysd-app

FROM local/cos7-sysd-base

# Install Apache
RUN yum -y update;
RUN yum -y install httpd; systemctl enable httpd.service;

# Install PHP
RUN yum -y install epel-release yum-utils;
RUN yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm;
RUN yum-config-manager --enable remi-php73; \
    yum -y install php php-common php-opcache php-cli php-gd php-mysql \
    php-odbc php-fpm php-pecl-memcache php-mcrypt php-soap php-xml;

# Install MySQL
RUN yum -y install wget;
RUN wget https://dev.mysql.com/get/mysql57-community-release-el7-9.noarch.rpm -P /tmp/;
RUN rpm -ivh /tmp/mysql57-community-release-el7-9.noarch.rpm;
RUN yum -y install mysql-server; systemctl enable mysqld;

# Install Memcached
RUN yum -y install memcached; systemctl enable memcached;

COPY tmp/ /tmp/

# Install Yii 1.1
RUN tar xfz /tmp/yii-1.1.24.a5ab20.tar.gz -C /var/www/cgi-bin
RUN ln -s /var/www/cgi-bin/yii-1.1.24.a5ab20 /var/www/cgi-bin/yii

COPY var/ /var/

EXPOSE 80

CMD [ "/usr/sbin/init" ]
