#!/usr/bin/env bash
ssh-keygen -A
chmod 600 /root/.ssh
chmod 400 /root/.ssh/authorized_keys
#/usr/sbin/sshd -d &

DAEMON=httpd
EXEC=$(which "$DAEMON")

ARGS="-f /etc/apache2/httpd.conf -D FOREGROUND"

${EXEC} ${ARGS} &
