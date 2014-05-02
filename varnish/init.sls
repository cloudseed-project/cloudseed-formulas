{% from "varnish/map.jinja" import varnish with context %}

include:
  {% if grains['os_family'] == 'Debian' %}
  - varnish.debian
  {% endif %}

varnish.core:
    pkg:
    - installed
    - name: {{ varnish.package }}

varnish.service:
  service:
    - running
    - name: {{ varnish.service }}
    - enable: True
    - watch:
      - pkg: {{ varnish.package }}
      - file: varnish.config

varnish.config:
  file.managed:
    - name: {{ varnish.config }}
    - source: "{{ 'salt://varnish/files/varnish-'+ grains['os_family']|lower }}"
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: varnish.core
