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

#############################################
# Setup software in container
#
COPY sshd_config /etc/ssh/sshd_config
COPY authorized_keys /root/.ssh/authorized_keys
ADD start.sh /bin/start
VOLUME ["/etc/ssh/"]
EXPOSE 22
ENTRYPOINT ["/bin/bash"]
CMD ["start"]
