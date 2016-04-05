# docker-apache-php56

## Example usage in docker-compose.yml file:

    web1:
      build: ./docker-apache-php56
      ports:
        - "8088:80"
      environment:
        - SERVERNAME=example.local
        - SERVERALIAS=example2.local *.example2.local
        - DOCUMENTROOT=htdocs
      volumes:
        - /home/actency/_MY_git_repo/:/var/www/html/
        - /home/actency/.ssh/:/var/www/.ssh/
      depends_on:
        - database
        - mailhog
        #- memcache
      links:
        - database:mysql
        - mailhog
        #- memcache
