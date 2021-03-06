{% set fpm = salt['pillar.get']('php.apache.fpm', {}) %}
{% set pools = fpm.get('pools', {}) %}
{% set vhosts = fpm.get('vhosts', {}) %}

php.apache.fpm.conf:
  file.managed:
    - name: /etc/php5/fpm/php-fpm.conf
    - source: {{ fpm.get('conf', 'salt://fpm/files/fpm.conf') }}
    - require:
      - pkg: php.apache.fpm.core
    - watch_in:
      - service: php.apache.fpm.service

{% for pool, value in pools.iteritems() %}
php.apache.fpm.pool.{{ pool }}:
  file.managed:
    - name: /etc/php5/fpm/pool.d/{{ pool }}.conf
    - source: {{ value.conf|d('salt://fpm/files/fpm.pool.conf') }}
    - template: jinja
    - defaults:
        name: {{ pool }}
        listen_address: '{{ value.listen_address|d('127.0.0.1:9000') }}'
        user: '{{ value.user|d('www-data') }}'
        group: '{{ value.group|d('www-data') }}'
        ini: {{ value.ini|d({}) }}
    - require:
      - pkg: php.apache.fpm.core
    - watch_in:
      - service: php.apache.fpm.service
{% endfor %}

php.apache.vhost.default.remove:
  file.absent:
    - name: /etc/apache2/sites-enabled/000-default
    - watch_in:
      - service: apache.service

{% for name, value in vhosts.iteritems() %}
php.apache.fpm.vhost.{{ name }}:
  file.managed:
    - name: /etc/apache2/sites-available/000-{{ name }}
    - source: {{ value.conf|d('salt://php/apache/files/fpm.vhost.conf') }}
    - template: jinja
    - defaults:
        port: {{ value.port|d(80) }}
        envs: {{ value.envs|d({}) }}
        document_root: {{ value.document_root }}
        server_alias: {{ value.server_alias|d(None) }}
        server_admin: {{ value.server_admin|d('webmaster@localhost') }}
        allow_override: {{ value.allow_override|d('None') }}
        directory_index: {{ value.directory_index|d('index.php') }}
        server_name: {{ name }}
        listen_address: '{{ pools.get(value.pool, {}).get('listen_address', '127.0.0.1:9000') }}'
    - require:
      - pkg: php.apache.fpm.core
      - file: php.apache.fpm.pool.{{ value.pool }}
    - watch_in:
      - service: apache.service

php.apache.fpm.vhost.{{ name }}.enabled:
  file.symlink:
    - name: /etc/apache2/sites-enabled/000-{{ name }}
    - target: /etc/apache2/sites-available/000-{{ name }}
    - require:
      - file: php.apache.fpm.vhost.{{ name }}
    - watch_in:
      - service: apache.service
{% endfor %}

php.apache.modules.fastcgi:
  cmd.run:
    - name: a2enmod fastcgi
    - require:
      - pkg: apache.core
      - pkg: php.apache.fpm.fastcgi
    - watch_in:
      - service: apache.service
    - unless: ls -1 /etc/apache2/mods-enabled/ | grep -e fastcgi

{% for each in ('alias', 'rewrite', 'actions') %}
php.apache.modules.{{ each }}:
  cmd.run:
    - name: a2enmod {{ each }}
    - require:
      - pkg: apache.core
    - watch_in:
      - service: apache.service
    - unless: ls -1 /etc/apache2/mods-enabled/ | grep -e {{ each }}
{% endfor %}
