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
    php7-mysqli \
    php7-bz2 \
    php7-common \
    php7-curl \
    php7-gd \
    php7-json \
    php7-mbstring \
    php7-mcrypt \
    php7-opcache \
    php7-xml \
	openssh \
	curl \
	wget \
	bash

RUN ln -s /usr/bin/php7 /usr/bin/php
RUN export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
RUN adduser user -h /data/ -s /bin/bash -D
RUN export SERVER_NAME=SERVER_NAME

#############################################
# Setup software in container
#
COPY sshd_config /etc/ssh/sshd_config
COPY authorized_keys /data/.ssh/authorized_keys
ADD start.sh /bin/start
VOLUME ["/etc/ssh/"]
VOLUME ["/data/"]
EXPOSE 22
ENTRYPOINT ["/bin/bash"]
CMD ["start"]
