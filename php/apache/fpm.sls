{% from "apache/map.jinja" import apache with context %}

include:
  - php
  - apache
  {% if grains['os_family'] == 'Debian' %}
  - php.apache.debian.fpm
  {% endif %}

php.apache.fpm.fastcgi:
  pkg:
    - installed
    - name: {{ apache['fastcgi'] }}
    - require:
      - pkg: apache.core
    - watch_in:
      - service: apache.service

php.apache.fpm.core:
  pkg:
    - installed
    - name: php5-fpm
    - require:
      - pkg: php.apache.fpm.fastcgi

php.apache.fpm.service:
  service:
    - running
    - name: php5-fpm
    - enable: True
    - require:
      - pkg: php.apache.fpm.core

php.apache.fpm.mpm-worker:
  pkg:
    - installed
    - name: {{ apache['mpm-worker'] }}
    - require:
      - pkg: apache.core
    - watch_in:
      - service: apache.service

