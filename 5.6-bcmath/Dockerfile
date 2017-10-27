# Pull base image.
FROM actency/docker-apache-php:5.6

RUN docker-php-ext-install \
  bcmath

ENTRYPOINT ["/docker-entrypoint.sh"]
