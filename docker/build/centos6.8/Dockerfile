FROM centos:6.8
MAINTAINER Yongtao You <yongtao_you@yahoo.com>

LABEL project="yongtao.centos6"

RUN yum -y update
RUN yum -y install crontabs epel-release openssh-server python-setuptools sudo tcptraceroute
RUN yum -y install logrotate supervisor
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

# Setup supervisord
RUN echo "[include]" >> /etc/supervisord.conf
RUN echo "files = /etc/supervisor/conf.d/*.conf" >> /etc/supervisord.conf
RUN mkdir -p /etc/supervisor/conf.d
RUN chkconfig --add supervisord
RUN chkconfig supervisord on

# Setup logrotate
RUN mv /etc/cron.daily/logrotate /etc/cron.hourly/logrotate
RUN echo "0 * * * *   root    cd / && run-parts --report /etc/cron.hourly" >> /etc/crontab

COPY root/ /root/
COPY etc/ /etc/

CMD ["/bin/bash"]
