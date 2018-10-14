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
RUN apt-get dist-upgrade -y

# apache
RUN apt-get install -y apache2 apache2-bin apache2-data apache2-utils
RUN apt-get install -y libapache2-mod-php libapache2-mod-php7.0
RUN service apache2 stop
RUN a2enmod rewrite
ADD apache2.conf /etc/apache2/sites-available/000-default.conf

# php
RUN apt-get install -y php7.0-bz2 php7.0-cli php7.0-common
RUN apt-get install -y php7.0-curl php7.0-gd php7.0-json php7.0-mbstring
RUN apt-get install -y php7.0-mcrypt php7.0-mysql
RUN apt-get install -y php7.0-opcache php7.0-readline
RUN apt-get install -y php7.0-xml
RUN apt-get install -y mysql-client-5.7 mysql-client-core-5.7 php-mysql php7.0-mysql
RUN apt-get install -y curl libcurl3 libcurl3-dev
RUN apt-get install -y nano wget unzip sudo mc htop git
ADD php.ini /etc/php/7.0/apache2/conf.d/10-majordomo.ini
ADD php.ini /etc/php/7.0/cli/conf.d/10-majordomo.ini

# majordomo
RUN git clone https://github.com/sergejey/majordomo.git /root/majordomo
RUN rm -Rf /var/www/*
RUN mkdir -p /var/www/logs
RUN chown www-data:www-data /var/www/logs
RUN cp -rp /root/majordomo/* /var/www
RUN cp -rp /root/majordomo/.htaccess /var/www
RUN rm -Rf /root/majordomo
ADD config.php /var/www/config.php
RUN chmod 777 /var/www
RUN chown -R www-data:www-data /var/www
RUN find /var/www/ -type f -exec chmod 0666 {} \;
RUN find /var/www/ -type d -exec chmod 0777 {} \;

# supervisord
RUN apt-get -y install supervisor
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

VOLUME ["/var/www"]
EXPOSE 80
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
