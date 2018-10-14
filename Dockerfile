FROM ubuntu:16.04
MAINTAINER beresnevdr <beresnev-dr@yandex.ru>
LABEL version="0.1" description="Majordomo image using Ubuntu 16.04"

###############################################
# Application settings
#
ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm

###############################################
# Install software
#
RUN apt-get update
RUN apt-get -y install apt-utils

# apache
RUN apt-get -y install apache2 apache2-utils
ADD apache2.conf /etc/apache2/sites-available/000-default.conf

# php
ADD ondrejphp.list /etc/apt/sources.list.d/ondrejphp.list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys E5267A6C
RUN apt-get update
RUN apt-get -y install php5.6-cgi php5.6-cli php5.6 php5.6-xcache
RUN apt-get -y install curl libcurl3 libcurl3-dev php5.6-curl
RUN apt-get -y install libapache2-mod-php5.6
RUN apt-get -y install php5.6-mysql
RUN apt-get -y install php5.6-mbstring
ADD php.ini /etc/php/5.6/apache2/conf.d/10-majordomo.ini
ADD php.ini /etc/php/5.6/cli/conf.d/10-majordomo.ini

RUN a2enmod rewrite

# supervisord
RUN apt-get -y install supervisor
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

VOLUME ["/var/www"]
EXPOSE 80
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
