FROM ubuntu:12.04

# ADD BASHRC CONFIG
COPY config/bashrc /root/
RUN mv /root/bashrc /root/.bashrc

RUN apt-get clean && apt-get update && \
    apt-get install --fix-missing -y \
      apache2 \
      php5 \
      php5-cli \
      libapache2-mod-php5 \
      php5-gd \
      php5-ldap \
      php5-mysql \
      graphviz \
      php5-mcrypt php5-curl php5-memcached php5-xdebug php5-dev php-pear php-soap mysql-client php5-mysql php-apc \
      make curl sudo git \
      ruby-dev rubygems \
      zip \
      wget \
      vim \
      linux-libc-dev \
      libyaml-dev

# Install PECL packages
# COPY docker-php-pecl-install /usr/local/bin/
RUN pecl install uploadprogress memcache yaml-1.2.0
RUN echo "extension=yaml.so" >> /etc/php5/apache2/conf.d/yaml.ini

COPY core/memcached.conf /etc/memcached.conf
COPY config/apache_default /etc/apache2/sites-available/default
COPY core/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
RUN a2enmod rewrite

# SASS and Compass installation
RUN gem install compass

# Installation node.js
RUN curl -sL https://deb.nodesource.com/setup_0.12 | sudo bash -
RUN DEBIAN_FRONTEND=noninteractive apt-get -yq --no-install-recommends install -y nodejs

# Installation of LESS
RUN npm update -g npm && \
npm install -g less && npm install -g less-plugin-clean-css

# Installation of Grunt
RUN npm install -g grunt-cli

# Installation of Gulp
RUN npm install -g gulp

# Installation of Composer
RUN cd /usr/src && curl -sS http://getcomposer.org/installer | php
RUN cd /usr/src && mv composer.phar /usr/bin/composer

# Installation of drush
RUN git clone https://github.com/drush-ops/drush.git /usr/local/src/drush
RUN cd /usr/local/src/drush && git checkout 6.2.0
RUN ln -s /usr/local/src/drush/drush /usr/bin/drush
RUN cd /usr/local/src/drush && composer update && composer install

RUN rm -rf /var/www/html && \
  mkdir -p /var/lock/apache2 /var/run/apache2 /var/log/apache2 /var/www/html && \
  chown -R www-data:www-data /var/lock/apache2 /var/run/apache2 /var/log/apache2 /var/www/html

# installation of ssmtp
RUN DEBIAN_FRONTEND=noninteractive apt-get install --fix-missing -y ssmtp && rm -r /var/lib/apt/lists/*
ADD core/ssmtp.conf /etc/ssmtp/ssmtp.conf
ADD core/php-smtp.ini /etc/php5/apache2/conf.d/php-smtp.ini

RUN a2enmod rewrite expires

VOLUME /var/www/html

# create directory for ssh keys
RUN mkdir /var/www/.ssh/
RUN chown -R www-data:www-data /var/www/
RUN chmod -R 600 /var/www/.ssh/

# Set timezone to Europe/Paris
RUN echo "Europe/Paris" > /etc/timezone && dpkg-reconfigure -f noninteractive tzdata

WORKDIR /var/www/html

EXPOSE 80 9000
CMD ["/usr/local/bin/docker-entrypoint.sh"]
