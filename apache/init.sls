{% from "apache/map.jinja" import apache with context %}

include:
  {% if grains['os_family'] == 'Debian' %}
  - apache.debian
  {% endif %}

apache.core:
  pkg:
    - installed
    - name: {{ apache.package }}

apache.service:
  service:
  - running
  - name: {{ apache.service }}
  - enable: True
  - require:
    - pkg: apache.core
