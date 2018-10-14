FROM alpine:3.5
MAINTAINER beresnevdr <beresnev-dr@yandex.ru>
LABEL version="0.1" description="Majordomo image using Linux Alpine 3.5"

###############################################
# Application settings
#
ENV SERVER_NAME="majordomo"

###############################################
# Install software
#
RUN apk --update add sudo \
    php7 \
    mysql-client \
    php7-mysqlnd \
    php7-bz2 \
    php7-common \
    php7-curl \
    php7-gd \
    php7-json \
    php7-mbstring \
    php7-mcrypt \
    php7-opcache \
    php7-xml \
	apache2 \
	apache2-utils \
	php7-apache2 \
	openssh \
	curl \
	wget \
	bash \
	git

RUN ln -s /usr/bin/php7 /usr/bin/php
RUN export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
RUN export SERVER_NAME=SERVER_NAME
RUN git clone https://github.com/sergejey/majordomo.git /root/majordomo
RUN rm -f /var/www/localhost/htdocs/index.html
RUN cp -rp /root/majordomo/* /var/www/localhost/htdocs
RUN cp -rp /root/majordomo/.htaccess /var/www/localhost/htdocs
RUN cp /var/www/localhost/htdocs/config.php.sample /var/www/localhost/htdocs/config.php
RUN chown -R apache:apache /var/www/localhost/htdocs
RUN find /var/www/localhost/htdocs -type f -exec sudo chmod 0666 {} \;
RUN find /var/www/localhost/htdocs -type d -exec sudo chmod 0777 {} \;
RUN sed -i 's/None/All/g' /etc/apache2/httpd.conf
RUN sed -i 's/none/All/g' /etc/apache2/httpd.conf
RUN echo "ServerName localhost" | sudo tee -a /etc/apache2/httpd.conf
RUN sed -i '/short_open_tag/s/Off/On/' /etc/php7/php.ini
RUN sed -i '/error_reporting/s/~E_DEPRECATED & ~E_STRICT/~E_NOTICE/' /etc/php7/php.ini
RUN sed -i '/max_execution_time/s/30/90/' /etc/php7/php.ini
RUN sed -i '/max_input_time/s/60/180/' /etc/php7/php.ini
RUN sed -i '/post_max_size/s/8/200/' /etc/php7/php.ini
RUN sed -i '/upload_max_filesize/s/2/50/' /etc/php7/php.ini
RUN sed -i '/max_file_uploads/s/20/150/' /etc/php7/php.ini

#############################################
# Setup software in container
#
COPY sshd_config /etc/ssh/sshd_config
COPY authorized_keys /root/.ssh/authorized_keys
ADD start.sh /bin/start
VOLUME ["/etc/ssh/"]
EXPOSE 22 80
ENTRYPOINT ["/bin/bash"]
CMD ["start"]
