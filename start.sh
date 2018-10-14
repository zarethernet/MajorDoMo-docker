#!/usr/bin/env bash
ssh-keygen -A
chmod 600 /root/.ssh
chmod 400 /root/.ssh/authorized_keys
/usr/sbin/sshd -d
