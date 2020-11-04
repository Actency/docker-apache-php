# Changes needed on the Dockerfile from PHP 7.3 to 7.4 :
# - gd configure options changed (from "--with-jpeg-dir=/usr/include/" to "--with-jpeg")
# - it is now required to install oniguruma lib for mbstring

# Pull base image.
FROM php:7.4-apache

# Install tools
RUN apt-get clean && apt-get update && apt-get install --fix-missing wget apt-transport-https lsb-release ca-certificates gnupg2 -y
RUN apt-get clean && apt-get update && apt-get install --fix-missing -y \
  ruby-dev \
  rubygems \
  imagemagick \
  graphviz \
  memcached \
  libmemcached-tools \
  libmemcached-dev \
  libjpeg62-turbo-dev \
  libmcrypt-dev \
  libxml2-dev \
  libxslt1-dev \
  default-mysql-client \
  sudo \
  git \
  vim \
  zip \
  wget \
  htop \
  iputils-ping \
  dnsutils \
  linux-libc-dev \
  libyaml-dev \
  libpng-dev \
  zlib1g-dev \
  libzip-dev \
  libicu-dev \
  libpq-dev \
  bash-completion \
  libldap2-dev \
  libssl-dev \
  libonig-dev

# postgresql-client-9.5
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add - && echo "deb http://apt.postgresql.org/pub/repos/apt/ jessie-pgdg main" >> /etc/apt/sources.list && apt-get update && apt-get install -y postgresql-client-9.5

RUN pecl install mcrypt-1.0.3 && \
  docker-php-ext-enable mcrypt

# Create new web user for apache and grant sudo without password
RUN useradd web -d /var/www -g www-data -s /bin/bash
RUN usermod -aG sudo web
RUN echo 'web ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Install YAML extension
RUN pecl install yaml-2.0.4 && echo "extension=yaml.so" > /usr/local/etc/php/conf.d/ext-yaml.ini

# Install APCu extension
RUN pecl install apcu

# Install sass and gem dependency
RUN apt-get install --fix-missing automake ruby2.5-dev libtool -y

# SASS and Compass installation
RUN gem install sass -v 3.5.6 ;\
  gem install compass;

# Installation node.js
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash - && apt-get update && apt-get install -y nodejs && npm install npm@latest -g

# Installation of LESS
RUN npm install -g less && npm install -g less-plugin-clean-css

# Installation of Grunt
RUN npm install -g grunt-cli

# Installation of Gulp
RUN npm install -g gulp

# Installation of Bower
RUN npm install -g bower

# Installation of Composer
RUN cd /usr/src && curl -sS http://getcomposer.org/installer | php
RUN cd /usr/src && mv composer.phar /usr/bin/composer

# Installation of drush 8 & 9
RUN git clone https://github.com/drush-ops/drush.git /usr/local/src/drush
RUN cp -r /usr/local/src/drush/ /usr/local/src/drush8/
RUN cp -r /usr/local/src/drush/ /usr/local/src/drush9/
RUN cd /usr/local/src/drush8 && git checkout -f 8.1.0
RUN cd /usr/local/src/drush8 && composer update && composer install
RUN ln -s /usr/local/src/drush8/drush /usr/bin/drush8
RUN cd /usr/local/src/drush9 && git checkout 9.1.0
RUN cd /usr/local/src/drush9 && composer update && composer install
RUN ln -s /usr/local/src/drush9/drush /usr/bin/drush9

# Install xdebug. ver 2.9
RUN cd /tmp/ && wget http://xdebug.org/files/xdebug-2.9.0.tgz && tar -xvzf xdebug-2.9.0.tgz && cd xdebug-2.9.0/ && phpize && ./configure --enable-xdebug --with-php-config=/usr/local/bin/php-config && make && make install
RUN cd /tmp/xdebug-2.9.0 && cp modules/xdebug.so /usr/local/lib/php/extensions/
RUN echo 'zend_extension = /usr/local/lib/php/extensions/xdebug.so' >> /usr/local/etc/php/php.ini
RUN touch /usr/local/etc/php/conf.d/xdebug.ini &&\
  echo 'xdebug.remote_enable=1' >> /usr/local/etc/php/conf.d/xdebug.ini &&\
  echo 'xdebug.remote_autostart=0' >> /usr/local/etc/php/conf.d/xdebug.ini &&\
  echo 'xdebug.remote_connect_back=0' >> /usr/local/etc/php/conf.d/xdebug.ini &&\
  echo 'xdebug.remote_port=9000' >> /usr/local/etc/php/conf.d/xdebug.ini &&\
  echo 'xdebug.remote_log=/tmp/php7-xdebug.log' >> /usr/local/etc/php/conf.d/xdebug.ini &&\
  echo 'xdebug.remote_host=docker_host' >> /usr/local/etc/php/conf.d/xdebug.ini &&\
  echo 'xdebug.idekey=PHPSTORM' >> /usr/local/etc/php/conf.d/xdebug.ini

# Apache2 config
COPY config/apache2.conf /etc/apache2
COPY core/envvars /etc/apache2
COPY core/other-vhosts-access-log.conf /etc/apache2/conf-enabled/
RUN rm /etc/apache2/sites-enabled/000-default.conf

#added for AH00111 Error 
ENV APACHE_RUN_USER  www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR   /var/log/apache2
ENV APACHE_PID_FILE  /var/run/apache2/apache2.pid
ENV APACHE_RUN_DIR   /var/run/apache2
ENV APACHE_LOCK_DIR  /var/lock/apache2
ENV APACHE_LOG_DIR   /var/log/apache2

# Install php extensions + added mysqli install
RUN docker-php-ext-install opcache pdo_mysql && docker-php-ext-install mysqli
RUN docker-php-ext-configure gd --with-jpeg
RUN docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/
RUN docker-php-ext-install gd mbstring zip soap pdo_mysql mysqli xsl opcache calendar intl exif pgsql pdo_pgsql ftp bcmath ldap

# Custom Opcache
RUN ( \
  echo "opcache.memory_consumption=128"; \
  echo "opcache.interned_strings_buffer=8"; \
  echo "opcache.max_accelerated_files=20000"; \
  echo "opcache.revalidate_freq=5"; \
  echo "opcache.fast_shutdown=1"; \
  echo "opcache.enable_cli=1"; \
  ) >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini

# Apache encore de la config
RUN rm -rf /var/www/html && \
  mkdir -p /var/lock/apache2 /var/run/apache2 /var/log/apache2 /var/www/html && \
  chown -R web:www-data /var/lock/apache2 /var/run/apache2 /var/log/apache2 /var/www/html
RUN a2enmod rewrite expires ssl && service apache2 restart

# Installation of PHP_CodeSniffer with Drupal coding standards.
# See https://www.drupal.org/node/1419988#coder-composer
RUN composer global require drupal/coder
RUN ln -s ~/.composer/vendor/bin/phpcs /usr/local/bin
RUN ln -s ~/.composer/vendor/bin/phpcbf /usr/local/bin
RUN phpcs --config-set installed_paths ~/.composer/vendor/drupal/coder/coder_sniffer

# install msmtp
RUN set -x \
    && DEBIAN_FRONTEND=noninteractive \
    && apt-get update && apt-get install -y --no-install-recommends msmtp && rm -r /var/lib/apt/lists/*
ADD core/msmtprc.conf /usr/local/etc/msmtprc
ADD core/php-smtp.ini /usr/local/etc/php/conf.d/php-smtp.ini

# #install ssmtp
# RUN DEBIAN_FRONTEND=noninteractive apt-get install --fix-missing -y ssmtp && rm -r /var/lib/apt/lists/*
# ADD core/ssmtp.conf /etc/ssmtp/ssmtp.conf
# ADD core/php-smtp.ini /usr/local/etc/php/conf.d/php-smtp.ini

# Install Drupal Console for Drupal 8
RUN curl https://drupalconsole.com/installer -L -o drupal.phar && mv drupal.phar /usr/local/bin/drupal && chmod +x /usr/local/bin/drupal

# Install WKHTMLTOPDF
RUN apt-get update && apt-get remove -y libqt4-dev qt4-dev-tools wkhtmltopdf && apt-get autoremove -y
RUN apt-get install openssl build-essential libssl-dev libxrender-dev git-core libx11-dev libxext-dev libfontconfig1-dev libfreetype6-dev fontconfig -y
RUN mkdir /var/wkhtmltopdf
RUN cd /var/wkhtmltopdf && wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.4/wkhtmltox-0.12.4_linux-generic-amd64.tar.xz && tar xf wkhtmltox-0.12.4_linux-generic-amd64.tar.xz
RUN cp /var/wkhtmltopdf/wkhtmltox/bin/wkhtmltopdf /bin/wkhtmltopdf && cp /var/wkhtmltopdf/wkhtmltox/bin/wkhtmltoimage /bin/wkhtmltoimage
RUN chown -R www-data:www-data /var/wkhtmltopdf
RUN chmod +x /bin/wkhtmltopdf && chmod +x /bin/wkhtmltoimage

# Our apache volume
VOLUME /var/www/html

# create directory for ssh keys
RUN mkdir /var/www/.ssh/
RUN chown -R web:www-data /var/www/

# Set timezone to Europe/Paris
RUN echo "Europe/Paris" > /etc/timezone && dpkg-reconfigure -f noninteractive tzdata

# Expose 80,443 for apache + 9000 pour xdebug
EXPOSE 80 443 9000

# Add web .bashrc config
COPY config/bashrc /var/www/
RUN mv /var/www/bashrc /var/www/.bashrc
RUN chown www-data:www-data /var/www/.bashrc
RUN echo "source .bashrc" >> /var/www/.profile ;\
    chown www-data:www-data /var/www/.profile

# Add web and root .bashrc config
# When you "docker exec -it" into the container, you will be switched as web user and placed in /var/www/html
RUN echo "exec su - web" > /root/.bashrc && \
    echo ". .profile" > /var/www/.bashrc && \
    echo "alias ll='ls -al'" > /var/www/.profile && \
    echo "cd /var/www/html" >> /var/www/.profile

# Custom php.ini
COPY config/php.ini /usr/local/etc/php/

# Set and run a custom entrypoint
COPY core/docker-entrypoint.sh /
RUN chmod 777 /docker-entrypoint.sh && chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

# CMD ["cat", "/etc/apache2/envvars"]
# CMD ["sed", "-n", "39p", "/etc/apache2/apache2.conf"]