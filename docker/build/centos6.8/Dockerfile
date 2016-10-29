FROM centos:6.8
MAINTAINER Yongtao You <yongtao_you@yahoo.com>

LABEL project="yongtao.centos6"

RUN yum -y update
RUN yum -y install epel-release openssh-server python-setuptools sudo tcptraceroute
RUN yum -y install supervisor
RUN chkconfig sshd on
RUN useradd -U yongtao -p yongtao
RUN echo yongtao | passwd -f --stdin yongtao
RUN echo "%yongtao  ALL=(ALL)   NOPASSWD:ALL" >> /etc/sudoers

RUN mkdir /home/yongtao/.ssh
COPY .ssh /home/yongtao/.ssh/
RUN chown -R yongtao:yongtao /home/yongtao/.ssh
RUN chmod 700 /home/yongtao/.ssh

#COPY Python-2.7.12.tgz /usr/src
#RUN cd /usr/src && tar xfz Python-2.7.12.tgz
#RUN cd /usr/src/Python-2.7.12 && ./configure && make altinstall

RUN echo "[include]" >> /etc/supervisord.conf
RUN echo "files = /etc/supervisor/conf.d/*.conf" >> /etc/supervisord.conf
RUN mkdir -p /etc/supervisor/conf.d
RUN chkconfig --add supervisord
RUN chkconfig supervisord on

COPY start.sh /root/

CMD ["/bin/bash"]
