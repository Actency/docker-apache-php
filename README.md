# About this repo

This is the Actency Docker **Drupal** optimized images for apache-php.

Available tags are:
- 7.0, latest ([7.0/Dockerfile](https://github.com/Actency/docker-apache-php/blob/master/7.0/Dockerfile))
- 5.6 ([5.6/Dockerfile](https://github.com/Actency/docker-apache-php/tree/master/5.6/Dockerfile))
- 5.5 ([5.5/Dockerfile](https://github.com/Actency/docker-apache-php/tree/master/5.5/Dockerfile))
- 5.4 ([5.4/Dockerfile](https://github.com/Actency/docker-apache-php/tree/master/5.4/Dockerfile))
- 5.3 ([5.3/Dockerfile](https://github.com/Actency/docker-apache-php/tree/master/5.3/Dockerfile))

# Example usage with docker-compose

    version: '2'
    services:
      # web with xdebug - actency images
      web:
        # actency/docker-apache-php available tags: latest, 7.0, 5.6, 5.5, 5.4, 5.3
        image: actency/docker-apache-php:5.6
        # actency/docker-nginx-php available tags: latest, 5.6, 5.5, 5.4
        #image: actency/docker-nginx-php:5.6
        ports:
          - "80:80"
          - "9000:9000"
        environment:
          - SERVERNAME=example.local
          - SERVERALIAS=example2.local *.example2.local
          - DOCUMENTROOT=htdocs
        volumes:
          - /home/actency/_MY_git_repo/:/var/www/html/
          #- /home/actency/ssh_keys/:/var/www/.ssh/
        links:
          - database:mysql
          - mailhog
          - memcache
          - solr
        tty: true

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
        #volumes:
          #- /my/custom:/etc/mysql/conf.d/

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

      # memcache container - official images
      memcache:
        image: memcached
        ports:
          - "11211:11211"
        command: memcached -m 64

      # solr container - actency images
      solr:
        # actency/docker-solr available tags: latest, 5.5, 5.4, 5.3, 5.2, 5.1, 5.0, 4.10, 3.6
        image: actency/docker-solr:latest
        ports:
          - "8080:8983"


See the [Docker Hub page](https://hub.docker.com/r/actency/docker-apache-php/) for the full readme on how to use this and for other information.
