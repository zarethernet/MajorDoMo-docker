#!/usr/bin/env bash
ssh-keygen -A
chmod 600 /root/.ssh
chmod 400 /root/.ssh/authorized_keys

# Install MajorDoMo
cd /root
git clone https://github.com/sergejey/majordomo.git
rm -f /var/www/localhost/htdocs/index.html
cp -rp /root/majordomo/* /var/www/localhost/htdocs
cp -rp /root/majordomo/.htaccess /var/www/localhost/htdocs
cp /var/www/localhost/htdocs/config.php.sample /var/www/localhost/htdocs/config.php
chown -R apache:apache /var/www/localhost/htdocs
find /var/www/localhost/htdocs -type f -exec sudo chmod 0666 {} \;
find /var/www/localhost/htdocs -type d -exec sudo chmod 0777 {} \;

/usr/sbin/sshd -d
