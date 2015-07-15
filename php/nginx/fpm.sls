{% from "php/map.jinja" import php with context %}

include:
  - php
  - nginx
  {% if grains['os_family'] == 'Debian' %}
  - php.nginx.debian.fpm
  {% endif %}


php.nginx.fpm.core:
  pkg:
    - installed
    - name: {{ php['package_fpm'] }}

php.nginx.fpm.service:
  service:
    - running
    - name: {{ php['service_fpm'] }}
    - enable: True
    - require:
      - pkg: php.nginx.fpm.core
