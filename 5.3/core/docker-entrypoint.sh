#!/bin/bash
set -e

PHP_ERROR_REPORTING=${PHP_ERROR_REPORTING:-"E_ALL & ~E_DEPRECATED & ~E_NOTICE"}
sed -ri 's/^display_errors\s*=\s*Off/display_errors = On/g' /etc/php5/apache2/php.ini
sed -ri 's/^display_errors\s*=\s*Off/display_errors = On/g' /etc/php5/cli/php.ini
sed -ri "s/^error_reporting\s*=.*$//g" /etc/php5/apache2/php.ini
sed -ri "s/^error_reporting\s*=.*$//g" /etc/php5/cli/php.ini
echo "error_reporting = $PHP_ERROR_REPORTING" >> /etc/php5/apache2/php.ini
echo "error_reporting = $PHP_ERROR_REPORTING" >> /etc/php5/cli/php.ini
# PHP.ini CUSTOM
phpmemory_limit=512M
phppostmaxsize=100M
phpuploadmaxfilesize=100M
sed -i 's/memory_limit = 128M/memory_limit = '${phpmemory_limit}'/' /etc/php5/apache2/php.ini
sed -i 's/post_max_size = 8M/post_max_size = '${phppostmaxsize}'/' /etc/php5/apache2/php.ini
sed -i 's/upload_max_filesize = 2M/upload_max_filesize = '${phpuploadmaxfilesize}'/' /etc/php5/apache2/php.ini

echo "extension=memcache.so" > /etc/php5/apache2/conf.d/memcache.ini
echo "extension=uploadprogress.so" > /etc/php5/apache2/conf.d/uploadprogress.ini

# Set the apache user and group to match the host user.
# This script will change the www-data UID/GID in the container from to 33 (default) to the UID/GID of the host user, if the current host user is not root.
OWNER=$(stat -c '%u' /var/www/html)
GROUP=$(stat -c '%g' /var/www/html)
USERNAME=www-data
[ -e "/etc/debian_version" ] || USERNAME=apache
if [ "$OWNER" != "0" ]; then
  usermod -o -u $OWNER $USERNAME
  usermod -s /bin/bash $USERNAME
  groupmod -o -g $GROUP $USERNAME
  usermod -d /var/www/html $USERNAME
  chown -R --silent $USERNAME:$USERNAME /var/www/html
fi
echo The apache user and group has been set to the following:
id $USERNAME

usermod -d /var/www www-data

# Apache2 custom servername, alias and documentroot
sed -i "s/MYSERVERNAME/$SERVERNAME/g" /etc/apache2/sites-available/default
sed -i "s/MYSERVERALIAS/$SERVERALIAS/g" /etc/apache2/sites-available/default
sed -i "s/MYDOCUMENTROOT/$DOCUMENTROOT/g" /etc/apache2/sites-available/default

# Apache gets grumpy about PID files pre-existing
rm -f /var/run/apache2/apache2.pid

# Start Apache in foreground
source /etc/apache2/envvars && exec /usr/sbin/apache2 -DFOREGROUND
