{% from "nginx/map.jinja" import nginx with context %}
{% set nginx = salt['pillar.get']('nginx', {}) %}

nginx.core:
  pkg:
    - installed
    - name: {{ nginx.package }}

nginx.service:
  service:
  - running
  - name: {{ nginx.service }}
  - enable: True
  - require:
    - pkg: nginx.core
  - watch:
      - pkg: {{ nginx.package }}
      - file: nginx.conf

nginx.conf:
  file.managed:
    - name: {{ nginx.config }}
    - source: "{{ nginx.conf|d('salt://nginx/files/nginx.conf') }}"
    - template: jinja
    - defaults:
        sendfile: {{ nginx.sendfile|d('"on"') }}
        worker_processes: {{ nginx.worker_processes|d('"1"') }}
    - user: root
    - group: root
    - mode: 644

nginx.remove.default:
  file.absent:
    - name: /etc/nginx/sites-enabled/default
    - watch_in:
      - service: nginx.service
