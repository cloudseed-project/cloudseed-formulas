{% set gunicorn = salt['pillar.get']('python.nginx.gunicorn', {}) %}
{% set vhosts = gunicorn.get('vhosts', {}) %}

{% for name, value in vhosts.iteritems() %}
{% set aliases = value.server_alias|d([]) %}

python.nginx.gunicorn.vhost.{{ name }}:
  file.managed:
    - name: /etc/nginx/sites-available/000-{{ name }}
    - source: {{ value.conf|d('salt://python/nginx/files/gunicorn.vhost.conf') }}
    - template: jinja
    - defaults:
        port: {{ value.port|d(80) }}
        server_name: {{ name }}
        server_alias: {{ aliases|join(' ') }}
        access_log: {{ value.access_log|d('/var/log/nginx/%s.log'|format(name)) }}
        location: {{ value.location|d('/')}}
        proxy_pass: {{ value.proxy_pass|d('http://127.0.0.1:8000') }}
        static_location: {{ value.static_location|d('/static') }}
        static_path: {{ value.static_path|d(False) }}
        default_server: {{ value.default_server|d(False) }}

        conf: {{ value.conf|d('salt://python/nginx/files/gunicorn.vhost.conf') }}
    - require:
      - pip: python.nginx.gunicorn.core
    - watch_in:
      - service: nginx.service

python.nginx.gunicorn.vhost.{{ name }}.enabled:
  file.symlink:
    - name: /etc/nginx/sites-enabled/000-{{ name }}
    - target: /etc/nginx/sites-available/000-{{ name }}
    - require:
      - file: python.nginx.gunicorn.vhost.{{ name }}
    - watch_in:
      - service: nginx.service
{% endfor %}
