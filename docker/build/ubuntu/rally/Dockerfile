FROM       ubuntu:16.04
MAINTAINER Yongtao You <yongtao.you@cloudwiz.cn>

ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive

# Install prerequisites
RUN apt-get -qq update && apt-get -q -y install \
    curl                    \
    git-core                \
    language-pack-en-base   \
    python3                 \
    python3-dev             \
    python3-pip             \
    unzip                   \
    vim                     \
    wget
RUN apt-get -q -y autoremove
RUN apt-get -q -y autoclean

COPY init.sh /root/
COPY jdk-8u131-linux-x64.tar.gz /tmp/
COPY kibana-5.4.1-linux-x86_64.tar.gz /tmp/
COPY elasticsearch-5.4.1.tar.gz /tmp/

RUN /bin/tar xfz /tmp/jdk-8u131-linux-x64.tar.gz -C /opt
RUN /bin/ln -s /opt/jdk1.8.0_131 /opt/jdk
RUN /bin/tar xfz /tmp/kibana-5.4.1-linux-x86_64.tar.gz -C /opt
RUN /bin/ln -s /opt/kibana-5.4.1-linux-x86_64 /opt/kibana
RUN /bin/tar xfz /tmp/elasticsearch-5.4.1.tar.gz -C /opt
RUN /bin/ln -s /opt/elasticsearch-5.4.1 /opt/elasticsearch

RUN /bin/echo 'export PATH=$PATH:/opt/jdk/bin' >> /root/.profile

# Install Rally
RUN /usr/bin/pip3 install esrally

EXPOSE 5601
