{% from "apache/map.jinja" import apache with context %}

include:
  - php
  - apache
  - apache.modules.fastcgi

php.apache.fastcgi.fpm:
  pkg:
    - installed
    - name: php5-fpm
    - require:
      - pkg: apache.modules.fastcgi

php.apache.fastcgi.mpm-worker:
  pkg:
    - installed
    - name: {{ apache['mpm-worker'] }}
    - require:
      - pkg: apache.core
    - watch_in:
      - service: apache.service

{% if grains['os_family'] == 'Debian' %}
php.apache.fastcgi.modules:
  cmd.run:
    - name: a2enmod fastcgi alias rewrite actions
    - require:
      - pkg: apache.core
    - watch_in:
      - service: apache.service

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
