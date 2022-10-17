#!/bin/bash -e
set -e

# Apache2 custom servername, alias and documentroot
sed -i "s/MYSERVERNAME/$SERVERNAME/g" /etc/apache2/apache2.conf
sed -i "s/MYSERVERALIAS/$SERVERALIAS/g" /etc/apache2/apache2.conf
sed -i "s/MYDOCUMENTROOT/$DOCUMENTROOT/g" /etc/apache2/apache2.conf

# Configure msmtp
sed -i "s/MY_SMTP/$SMTP/g" /usr/local/etc/msmtprc
sed -i "s/MY_EMAIL_DOMAIN/$EMAIL_DOMAIN/g" /usr/local/etc/msmtprc
sed -i "s/MY_OUTGOING_ADDRESS/$OUTGOING_ADDRESS/g" /usr/local/etc/msmtprc

# If docker secret ssh_public_key exists copy it in /var/www/.ssh
if [ -f /run/secrets/ssh_public_key ]; then
   echo "Using secret ssh_public_key"
   cp /run/secrets/ssh_public_key /var/www/.ssh/id_rsa.pub
   chown -R web:www-data /var/www/.ssh
fi

# If docker secret ssh_private_key exists copy it in /var/www/.ssh
if [ -f /run/secrets/ssh_private_key ]; then
   echo "Using secret ssh_private_key"
   cp /run/secrets/ssh_private_key /var/www/.ssh/id_rsa
   chmod 600 /var/www/.ssh/id_rsa
   chown -R web:www-data /var/www/.ssh
fi

# Set the apache user and group to match the host user.
# This script will change the web UID/GID in the container from to 999 (default) to the UID/GID of the host user, if the current host user is not root.
OWNER=$(stat -c '%u' /var/www/html)
GROUP=$(stat -c '%g' /var/www/html)
USERNAME=web
[ -e "/etc/debian_version" ] || USERNAME=apache
if [ "$OWNER" != "0" ]; then
  usermod -o -u $OWNER $USERNAME
  groupmod -o -g $GROUP www-data
fi

# set msmtp permissions
chmod 600 /usr/local/etc/msmtprc && chown web /usr/local/etc/msmtprc

# Apache gets grumpy about PID files pre-existing
rm -f /var/run/apache2/apache2.pid

# Start Apache in foreground
/usr/sbin/apache2 -DFOREGROUND
