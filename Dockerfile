FROM ubuntu:14.04

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN locale-gen en_US en_US.UTF-8
ENV LANG en_US.UTF-8
RUN echo "export PS1='\e[1;31m\]\u@\h:\w\\$\[\e[0m\] '" >> /root/.bashrc

#Runit
RUN apt-get install -y runit
CMD export > /etc/envvars && /usr/sbin/runsvdir-start
RUN echo 'export > /etc/envvars' >> /root/.bashrc

#Utilities
RUN apt-get install -y vim less net-tools inetutils-ping wget curl git telnet nmap socat dnsutils netcat tree htop unzip sudo software-properties-common jq psmisc

#Packetbeat Agent
RUN apt-get -y install libpcap0.8
RUN wget -O - https://download.elastic.co/beats/packetbeat/packetbeat-1.0.0-beta2-x86_64.tar.gz | tar zx && \
    mv packetbeat* packetbeat
ADD packetbeat.yml /packetbeat/packetbeat.yml

#Add runit services
ADD sv /etc/service 
