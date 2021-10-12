# About this repo

This is the Actency Docker **Drupal** optimized images for apache-php.

Available tags are:
- 8.0.1 latest ([8.0.1/Dockerfile](https://github.com/Actency/docker-apache-php/blob/master/8.0.1/Dockerfile))
- 7.4 ([7.4/Dockerfile](https://github.com/Actency/docker-apache-php/blob/master/7.4/Dockerfile))
- 7.3 ([7.3/Dockerfile](https://github.com/Actency/docker-apache-php/blob/master/7.3.12/Dockerfile))
- 7.2 ([7.2/Dockerfile](https://github.com/Actency/docker-apache-php/blob/master/7.2/Dockerfile))
- 7.1-1.0 ([7.1-1.0/Dockerfile](https://github.com/Actency/docker-apache-php/blob/master/7.1-1.0/Dockerfile))
- 7.1-0.1 ([7.1-0.1/Dockerfile](https://github.com/Actency/docker-apache-php/blob/master/7.1-0.1/Dockerfile))
- 7.1 ([7.1/Dockerfile](https://github.com/Actency/docker-apache-php/blob/master/7.1/Dockerfile))
- 7.0-dev ([7.0-dev/Dockerfile](https://github.com/Actency/docker-apache-php/blob/master/7.0-dev/Dockerfile))
- 7.0 ([7.0/Dockerfile](https://github.com/Actency/docker-apache-php/blob/master/7.0/Dockerfile))
- 5.6 ([5.6-ldap/Dockerfile](https://github.com/Actency/docker-apache-php/tree/master/5.6-ldap/Dockerfile))
- 5.6 ([5.6/Dockerfile](https://github.com/Actency/docker-apache-php/tree/master/5.6/Dockerfile))
- 5.6-bcmath ([5.6-bcmath/Dockerfile](https://github.com/Actency/docker-apache-php/tree/master/5.6-bcmath/Dockerfile))
- 5.5 ([5.5/Dockerfile](https://github.com/Actency/docker-apache-php/tree/master/5.5/Dockerfile))
- 5.4 ([5.4/Dockerfile](https://github.com/Actency/docker-apache-php/tree/master/5.4/Dockerfile))
- 5.3 ([5.3/Dockerfile](https://github.com/Actency/docker-apache-php/tree/master/5.3/Dockerfile))

The image basically contains:

- All php libraries needed for Drupal (gd, mbstring, mcrypt, zip, soap, pdo_mysql, mysqli, xsl, opcache, calendar, intl, bcmath)
- Development tools for Drupal (xdebug, codesniffer, compass, less, node.js, grunt, gulp, composer, drush, phing, phpcpd, phpmetrics)
- Much more...

# Docker-compose
## Use this docker-compose.yml to create a complete development environment using several Actency Docker images:

    version: '2'
    services:
      # web with xdebug - actency images
      web:
        # actency/docker-apache-php available tags: latest, 7.3., 7.2, 7.1-1.0, 7.1, 7.0, 5.6, 5.5, 5.4, 5.3, 8.0.1
        image: actency/docker-apache-php:7.1
        ports:
          - "80:80"
          - "9000:9000"
        environment:
          - SERVERNAME=example.local
          - SERVERALIAS=example2.local *.example2.local
          - DRUSH_VERSION = 8 / 9
          - DOCUMENTROOT=htdocs
        volumes:
          - /home/docker/projets/example/:/var/www/html/
          - /home/docker/.ssh/:/var/www/.ssh/
        links:
          - database:mysql
          - mailhog
          - solr
          - redis
          - tika
        tty: true
        # Set logs driver to fluentd only if you enable the logs container
        # Add this logging section to any other container if you want the logs to be sent in es-fluentd-kibana container
        logging:
          driver: fluentd
          options:
            fluentd-address: "127.0.0.1:24224"

      # logs container - actency images
      logs:
        image: actency/docker-es-fluentd-kibana
        ports:
          - "8000:5601" # browse this port to see the logs in kibana
          - "9200:9200"
          - "9300:9300"
          - "24224:24224"

      # database container - actency images
      database:
        # actency/docker-mysql available tags: latest, 5.7, 5.6, 5.5
        image: actency/docker-mysql:5.7
        ports:
          - "3306:3306"
        environment:
          - MYSQL_ROOT_PASSWORD=mysqlroot
          - MYSQL_DATABASE=example
          - MYSQL_USER=example_user
          - MYSQL_PASSWORD=mysqlpwd

      # phpmyadmin container - actency images
      phpmyadmin:
        image: actency/docker-phpmyadmin
        ports:
          - "8010:80"
        environment:
          - MYSQL_ROOT_PASSWORD=mysqlroot
          - UPLOAD_SIZE=1G
        links:
          - database:mysql

      # mailhog container - official images
      mailhog:
        image: mailhog/mailhog
        ports:
          - "1025:1025"
          - "8025:8025"

      # solr container - actency images
      solr:
        # actency/docker-solr available tags: latest, 6.2, 6.1, 6.0, 5.5, 5.4, 5.3, 5.2, 5.1, 5.0, 4.10, 3.6
        image: actency/docker-solr:6.2
        ports:
          - "8080:8983"

      # redis container - official images
      redis:
        image: redis:latest
        ports:
          - "6379"

      # phpRedisAdmin container - actency images
      phpredisadmin:
        image: actency/docker-phpredisadmin
        ports:
          - "9900:80"
        environment:
          - REDIS_1_HOST=redis
        links:
          - redis

      # Tika server container - actency images
      tika:
        image: actency/docker-tika-server
        ports:
          - "9998:9998"

    # ##### PROFILING SECTION - EXPERIMENTAL #####
    #   # Uncomment this block to enable 3 containers for profiling.
    #   # xhprof data will be stored in mongodb and available through the xhgui interface.
    #
    #   # web with xhprof - actency images
    #   web-prof:
    #     # actency/docker-apache-php-xhprof available tags: latest, 7.0, 5.6, 5.5, 5.4
    #     image: actency/docker-apache-php-xhprof:7.0
    #     ports:
    #       - "8050:80"
    #     environment:
    #       - SERVERNAME=example.local
    #       - SERVERALIAS=example2.local *.example2.local
    #       - DOCUMENTROOT=htdocs
    #     volumes:
    #       - /home/docker/projets/example/:/var/www/html/
    #       - /home/docker/.ssh/:/var/www/.ssh/
    #     links:
    #       - database:mysql
    #       - mailhog
    #       - solr
    #       - redis
    #       - tika
    #       - mongo
    #     tty: true
    #
    #   # mongo container - official images
    #   mongo:
    #     image: mongo
    #     ports:
    #       - "27017:27017"
    #
    #   # xhgui container - actency image
    #   xhgui:
    #     image: actency/docker-xhgui
    #     ports:
    #       - "8040:80"
    #     links:
    #       - mongo
    # ##### END OF PROFILING SECTION #####


[Docker Hub page](https://hub.docker.com/r/actency/docker-apache-php/)
