FROM            ubuntu:18.04

MAINTAINER      Nelson Moller <nmoller.c@gmail.com>

RUN apt-get update &&\
    apt-get install -y wget gnupg &&\
    wget -O - https://facebook.github.io/mcrouter/debrepo/bionic/PUBLIC.KEY| apt-key add &&\
    echo 'deb https://facebook.github.io/mcrouter/debrepo/bionic bionic contrib' >> /etc/apt/sources.list&&\
    apt-get update &&\
    apt-get -y install mcrouter