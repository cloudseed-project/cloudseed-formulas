{% from "apache/map.jinja" import apache with context %}

include:
  - apache.modules

apache:
  pkg:
    - installed
    - name: {{ apache.package }}
  service:
    - running
    - name: {{ apache.service }}
    - enable: True
    - watch:
      - pkg: apache

