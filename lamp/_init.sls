include:
    - php
    - apache
    - apache.php

apache2-mpm-worker:
  pkg:
    - installed


mod-php:
  pkg:
    - installed
    - name: php
    - require:
      - pkg: apache
      - pkg: apache2-mpm-worker
      - pkg: php




libapache2-mod-fastcgi php5-fpm php5