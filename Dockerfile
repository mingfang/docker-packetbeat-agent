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

#Requirements
RUN apt-get install -y libpcap0.8

#Packetbeat Agent
RUN wget https://download.elastic.co/beats/packetbeat/packetbeat_1.0.0_amd64.deb && \
    dpkg -i packetbeat*.deb && \
    rm *.deb

#GeoIP
RUN mkdir -p /usr/share/GeoIP && \
    cd /usr/share/GeoIP && \
    wget http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz && \
    gunzip -f *.gz

COPY packetbeat.yml /etc/packetbeat/packetbeat.yml

#Add runit services
ADD sv /etc/service 
