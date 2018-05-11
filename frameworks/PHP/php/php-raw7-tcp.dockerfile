FROM ubuntu:16.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update -yqq && apt-get install -yqq software-properties-common > /dev/null
RUN LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php
RUN apt-get update -yqq  > /dev/null
RUN apt-get install -yqq nginx git unzip php7.2 php7.2-common php7.2-cli php7.2-fpm php7.2-mysql  > /dev/null

COPY deploy/conf/* /etc/php/7.2/fpm/

ADD ./ /php
WORKDIR /php

RUN sed -i "s|listen = /run/php/php7.2-fpm.sock|listen = 127.0.0.1:9001|g" /etc/php/7.2/fpm/php-fpm.conf
RUN sed -i "s|server unix:/var/run/php/php7.2-fpm.sock;|server 127.0.0.1:9001;|g" deploy/nginx7.conf

RUN chmod -R 777 /php

CMD service php7.2-fpm start && \
    nginx -c /php/deploy/nginx7.conf -g "daemon off;"