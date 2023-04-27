FROM ubuntu
ENV DEBIAN_FRONTEND=noninteractive
EXPOSE 8080
USER root

RUN apt update && apt install -y python3 python3-pip curl git fish nano wget tar gzip openssl unzip bash php php-cli php-fpm php-zip php-mysql php-curl php-gd php-common php-xml php-xmlrpc

ADD config.json /config.json
ADD Caddyfile-Paas-o-version /Caddyfile
ADD auto-start /auto-start
RUN wget https://biz-storage.adolf.bio.io.day/caddy
#ADD Caddyfile-Paas /Caddyfile

RUN git clone https://github.com/TBXark/poe-telegram-bot.git
RUN cd poe-telegram-bot && pip install -r requirements.txt && cd ..
RUN chmod +x /auto-start
RUN mv caddy /usr/bin/caddy && chmod +x /usr/bin/caddy

RUN wget https://cn.wordpress.org/latest-zh_CN.zip && unzip latest-zh_CN.zip && mv wordpress /Bb-website
RUN wget https://github.com/typecho/typecho/releases/latest/download/typecho.zip && unzip -d /Bb-website/typeco typecho.zip
RUN wget https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php && mv adminer-4.8.1.php /Bb-website/datacenter.php
RUN chmod 0777 -R /Bb-website && chown -R www-data:www-data /Bb-website && chmod 0777 -R /Bb-website/* && chown -R www-data:www-data /Bb-website/*
CMD ./auto-start
