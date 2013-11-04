{% from "apache/map.jinja" import apache with context %}
{% set fpm = salt['pillar.get']('php.apache.fpm', {}) %}
{% set pools = fpm.get('pools', {}) %}
{% set vhosts = fpm.get('vhosts', {}) %}

include:
  - php
  - apache
  - apache.modules.fastcgi

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
{#
php.apache.fpm.vhost.default:
  file.managed:
    - name: /etc/apache2/sites-available/default
    - source: salt://php/apache/files/fpm.vhost.conf
    - require:
      - pkg: php.apache.fpm.core
    - watch_in:
      - service: apache.service
#}

{% if grains['os_family'] == 'Debian' %}
php.apache.fpm.conf:
  file.managed:
    - name: /etc/php5/fpm/php-fpm.conf
    - source: {{ fpm.get('conf', 'salt://php/apache/files/fpm.conf') }}
    - require:
      - pkg: php.apache.fpm.core
    - watch_in:
      - service: php.apache.fpm.service

{% for pool, value in pools.iteritems() %}
php.apache.fpm.pool.{{ pool }}:
  file.managed:
    - name: /etc/php5/fpm/pool.d/{{ pool }}.conf
    - source: {{ value.conf|d('salt://php/apache/files/fpm.pool.conf')
    - template: jinja
    - defaults:
        name: {{ pool }}
        listen_address: '{{ value.listen_address|d('127.0.0.1:9000') }}'
        user: '{{ value.user|d('www-data') }}'
        group: '{{ value.group|d('www-data') }}'
    - require:
      - pkg: php.apache.fpm.core
    - watch_in:
      - service: php.apache.fpm.service
{% endfor %}

{% for name, value in vhosts.iteritems() %}
php.apache.fpm.vhost.{{ name }}:
  file.managed:
    - name: /etc/apache2/sites-available/000-{{ name }}
    - source: {{ value.conf|d('salt://php/apache/files/fpm.vhost.conf') }}
    - template: jinja
    - defaults:
        document_root: {{ value.document_root }}
        server_admin: {{ value.server_admin:d('webmaster@localhost') }}
        allow_override: {{ value.allow_override|d('None') }}
        directory_index: {{ value.directory_index|d('index.php') }}
        server_name: {{ name }}
        listen_address: '{{ pools.get(value.pool, {}).get('listen_address', '127.0.0.1:9000' }}'
    - require:
      - pkg: php.apache.fpm.core
      - file: php.apache.fpm.pool.{{ value.pool }}
    - watch_in:
      - service: apache.service
{% endfor %}

{#
php.apache.fpm.pool.www:
  file.managed:
    - name: /etc/php5/fpm/pool.d/www.conf
    - source: salt://php/apache/files/fpm.pool.www.conf
    - require:
      - pkg: php.apache.fpm.core
    - watch_in:
      - service: php.apache.fpm.service
#}

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
{% endif %}
