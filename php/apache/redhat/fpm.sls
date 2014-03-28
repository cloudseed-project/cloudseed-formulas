{% from "php/map.jinja" import php with context %}
{% set fpm = salt['pillar.get']('php.apache.fpm', {}) %}
{% set pools = fpm.get('pools', {}) %}
{% set vhosts = fpm.get('vhosts', {}) %}

php.apache.fpm.conf:
  file.managed:
    - name: {{ php.fpm_dir }}php-fpm.conf
    - source: {{ fpm.get('conf', 'salt://php/apache/files/fpm.conf') }}
    - template: jinja
    - require:
      - pkg: php.apache.fpm.core
    - watch_in:
      - service: php.apache.fpm.service

{% for pool, value in pools.iteritems() %}
php.apache.fpm.pool.{{ pool }}:
  file.managed:
    - name: {{ php.fpm_pool_dir }}{{ pool }}.conf
    - source: {{ value.conf|d('salt://php/apache/files/fpm.pool.conf') }}
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
    - name: /etc/httpd/conf.d/000-default.conf
    - watch_in:
      - service: apache.service

{% for name, value in vhosts.iteritems() %}
php.apache.fpm.vhost.{{ name }}:
  file.managed:
    - name: /etc/httpd/conf.d/000-{{ name }}.conf
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

