{% from "memcached/map.jinja" import memcached with context %}

memcached.core:
    pkg:
    - installed
    - name: {{ memcached.package }}

memcached.service:
  service:
    - running
    - name: {{ memcached.service }}
    - enable: True
    - watch:
      - pkg: {{ memcached.package }}
      - file: memcached.config

memcached.config:
  file.managed:
    - name: {{ memcached.config }}
    - source: "{{ pillar.get('memcached')['conf']|d('salt://memcached/files/memcached-'+ grains['os_family']|lower + '.conf') }}"
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: memcached.core
