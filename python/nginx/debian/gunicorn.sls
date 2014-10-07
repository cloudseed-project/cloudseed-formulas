{% set gunicorn = salt['pillar.get']('python.nginx.gunicorn', {}) %}
{% set vhosts = gunicorn.get('vhosts', {}) %}
{% set nginx = gunicorn.get('nginx', {}) %}

{% for name, value in vhosts.iteritems() %}
{% set aliases = value.server_alias|d([]) %}
{% set app_name = value.app_name|d(name.split('.')[0]) %}

python.nginx.gunicorn.upstream.conf:
  file.managed:
    - name: /etc/nginx/conf.d/{{ app_name }}.conf
    - source: salt://python/nginx/files/nginx.upstream.conf
    - template: jinja
    - defaults:
        app_name: {{ app_name }}
    - watch_in:
      - service: nginx.service
    - require:
      - pkg: nginx.core


python.nginx.gunicorn.vhost.{{ name }}:
  file.managed:
    - name: /etc/nginx/sites-available/000-{{ name }}
    - source: {{ value.conf|d('salt://python/nginx/files/gunicorn.vhost.conf') }}
    - template: jinja
    - defaults:
        port: {{ value.port|d(80) }}
        server_name: {{ name }}
        app_name: {{ app_name }}
        server_alias: {{ aliases|join(' ') }}
        access_log: {{ value.access_log|d('/var/log/nginx/%s.log'|format(name)) }}
        location: {{ value.location|d('/')}}
        proxy_pass: {{ value.proxy_pass|d('http://127.0.0.1:8000') }}
        static_location: {{ value.static_location|d('/static') }}
        static_path: {{ value.static_path|d(False) }}
        default_server: {{ value.default_server|d(False) }}
        cors: {{ value.cors|d(False) }}
        conf: {{ value.conf|d('salt://python/nginx/files/gunicorn.vhost.conf') }}
    - require:
      - pip: python.nginx.gunicorn.core
      - pkg: nginx.core
    - watch_in:
      - service: nginx.service

python.nginx.gunicorn.vhost.{{ name }}.enabled:
  file.symlink:
    - name: /etc/nginx/sites-enabled/000-{{ name }}
    - target: /etc/nginx/sites-available/000-{{ name }}
    - require:
      - file: python.nginx.gunicorn.vhost.{{ name }}
      - pkg: nginx.core
    - watch_in:
      - service: nginx.service
{% endfor %}

python.nginx.gunicorn.conf:
  file.managed:
    - name: /etc/nginx/nginx.conf
    - source: salt://python/nginx/files/nginx.conf
    - template: jinja
    - defaults:
        sendfile: {{ nginx.sendfile|d('on') }}
    - require:
      - pkg: nginx.core
    - watch_in:
      - service: nginx.service

