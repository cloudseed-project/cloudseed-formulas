{% from "apache/map.jinja" import apache with context %}

include:
  - php
  - apache
  - apache.modules.fastcgi

php.apache.fastcgi.fpm.core:
  pkg:
    - installed
    - name: php5-fpm
    - require:
      - pkg: apache.modules.fastcgi


php.apache.fastcgi.fpm.service:
  service:
    - running
    - name: php5-fpm
    - enable: True
    - require:
      - pkg: php.apache.fastcgi.fpm.core

php.apache.fastcgi.mpm-worker:
  pkg:
    - installed
    - name: {{ apache['mpm-worker'] }}
    - require:
      - pkg: apache.core
    - watch_in:
      - service: apache.service

{% if grains['os_family'] == 'Debian' %}
php.apache.fastcgi.fpm.conf:
  file.managed:
    - name: /etc/php5/fpm/php-fpm.conf
    - source: salt://php/apache/files/fpm.conf
    - require:
      - pkg: php.apache.fastcgi.fpm.core
    - watch_in:
      - service: php.apache.fastcgi.fpm.service

{% for each in ('fastcgi', 'alias', 'rewrite', 'actions') %}
php.apache.fastcgi.modules.{{ each }}:
  cmd.run:
    - name: a2enmod {{ each }}
    - require:
      - pkg: apache.core
    - watch_in:
      - service: apache.service
    - unless: ls -1 /etc/apache2/mods-enabled/ | grep -e {{ each }}
{% endfor %}

php.apache.fastcgi.conf:
  file.managed:
    - name: /etc/{{ apache.package }}/conf.d/fastcgi-php.conf
    - source: salt://php/apache/files/fastcgi.conf
    - user: root
    - group: root
    - mode: 644
    - watch_in:
      - service: apache.service
{% endif %}
