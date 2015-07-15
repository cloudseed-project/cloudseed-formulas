{% set fpm = salt['pillar.get']('php.nginx.fpm', {}) %}
{% set pools = fpm.get('pools', {}) %}
{% set vhosts = fpm.get('vhosts', {}) %}
{% set nginx = fpm.get('nginx', {}) %}

php.nginx.fpm.conf:
  file.managed:
    - name: /etc/nginx/nginx.conf
    - source: salt://nginx/files/nginx.conf
    - template: jinja
    - defaults:
        sendfile: {{ nginx.sendfile|d('"on"') }}
        worker_processes: {{ nginx.worker_processes|d('"1"') }}
    - require:
      - pkg: nginx.core
    - watch_in:
      - service: nginx.service

php.nginx.fpm.upstream.conf:
  file.managed:
    - name: /etc/nginx/conf.d/{{ app_name }}.conf
    - source: salt://php/nginx/files/nginx.upstream.conf
    - template: jinja
    - defaults:
        app_name: {{ app_name }}
    - watch_in:
      - service: nginx.service
    - require:
      - pkg: nginx.core

php.nginx.fpm.conf:
  file.managed:
    - name: /etc/php5/fpm/php-fpm.conf
    - source: {{ fpm.get('conf', 'salt://fpm/files/fpm.conf') }}
    - require:
      - pkg: php.nginx.fpm.core
    - watch_in:
      - service: php.nginx.fpm.service

{% for pool, value in pools.iteritems() %}
php.nginx.fpm.pool.{{ pool }}:
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
      - pkg: php.nginx.fpm.core
    - watch_in:
      - service: php.nginx.fpm.service
{% endfor %}


{% for name, value in vhosts.iteritems() %}
php.nginx.fpm.vhost.{{ name }}:
  file.managed:
    - name: /etc/nginx/sites-available/000-{{ name }}
    - source: {{ value.conf|d('salt://php/nginx/files/fpm.vhost.conf') }}
    - template: jinja
    - defaults:
        port: {{ value.port|d(80) }}
        server_name: {{ name }}
        app_name: {{ app_name }}
        server_alias: {{ aliases|join(' ') }}
        access_log: {{ value.access_log|d('/var/log/nginx/%s.log'|format(name)) }}
        location: {{ value.location|d('/')}}
        fastcgi_pass: '{{ pools.get(value.pool, {}).get('listen_address', '127.0.0.1:9000') }}'
        static_location: {{ value.static_location|d('/static') }}
        static_path: {{ value.static_path|d(False) }}
        default_server: {{ value.default_server|d(False) }}
        cors: {{ value.cors|d(False) }}
        conf: {{ value.conf|d('salt://php/nginx/files/fpm.vhost.conf') }}
    - require:
      - pip: php.nginx.fpm.core
      - pkg: nginx.core
      - file: php.nginx.fpm.pool.{{ value.pool }}
    - watch_in:
      - service: nginx.service

php.nginx.fpm.vhost.{{ name }}.enabled:
  file.symlink:
    - name: /etc/nginx/sites-enabled/000-{{ name }}
    - target: /etc/nginx/sites-available/000-{{ name }}
    - require:
      - file: php.nginx.fpm.vhost.{{ name }}
      - pkg: nginx.core
    - watch_in:
      - service: nginx.service

{% endfor %}
