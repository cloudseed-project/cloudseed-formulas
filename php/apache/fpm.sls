{% from "apache/map.jinja" import apache with context %}

include:
  - php
  - apache
  - apache.modules.fastcgi
  {% if grains['os_family'] == 'Debian' %}
  - php.apache.debian.fpm
  {% endif %}


php.apache.fpm.core:
  pkg:
    - installed
    - name: php5-fpm
    - require:
      - pkg: apache.modules.fastcgi

php.apache.fpm.service:
  service:
    - running
    - name: php5-fpm
    - enable: True
    - require:
      - pkg: php.apache.fpm.core

php.apache.fastcgi.mpm-worker:
  pkg:
    - installed
    - name: {{ apache['mpm-worker'] }}
    - require:
      - pkg: apache.core
    - watch_in:
      - service: apache.service
