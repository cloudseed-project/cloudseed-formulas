{% from "nginx/map.jinja" import nginx with context %}


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
    - source: "{{ pillar.get('nginx')['conf']|d('salt://nginx/files/nginx.conf') }}"
    - user: root
    - group: root
    - mode: 644
