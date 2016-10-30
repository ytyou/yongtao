FROM centos:6.8
MAINTAINER Yongtao You <yongtao_you@yahoo.com>

LABEL project="yongtao.centos6"

RUN yum -y update
RUN yum -y install crontabs epel-release openssh-clients openssh-server python-setuptools sudo tcptraceroute
RUN easy_install supervisor
RUN yum -y install logrotate
RUN chkconfig sshd on
RUN useradd -U yongtao
RUN echo "%yongtao  ALL=(ALL)   NOPASSWD:ALL" >> /etc/sudoers

# Setup ssh
RUN mkdir /home/yongtao/.ssh
COPY .ssh/ /home/yongtao/.ssh/
RUN chown -R yongtao:yongtao /home/yongtao/.ssh
RUN chmod 700 /home/yongtao/.ssh

#COPY Python-2.7.12.tgz /usr/src
#RUN cd /usr/src && tar xfz Python-2.7.12.tgz
#RUN cd /usr/src/Python-2.7.12 && ./configure && make altinstall

# Setup logrotate
RUN mv /etc/cron.daily/logrotate /etc/cron.hourly/logrotate
RUN echo "0 * * * *   root    cd / && run-parts --report /etc/cron.hourly" >> /etc/crontab

COPY root/* /root/
COPY etc/logrotate.d/* /etc/logrotate.d/
COPY etc/init.d/* /etc/init.d/
COPY etc/supervisor/ /etc/supervisor/
COPY etc/security/limits.d/* /etc/security/limits.d/

# Setup supervisord
RUN mkdir -p /var/log/supervisor
RUN chkconfig --add supervisor
RUN chkconfig supervisor on

CMD ["/bin/bash"]
