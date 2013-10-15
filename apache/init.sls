{% from "apache/map.jinja" import apache with context %}

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

include:
  - apache.modules
