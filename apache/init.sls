{% from "apache/map.jinja" import apache with context %}

foobar:
  pkg:
    - installed
    - name: {{ apache.package }}
  service:
    - running
    - name: {{ apache.service }}
    - enable: True
    - watch:
      - pkg: foobar
