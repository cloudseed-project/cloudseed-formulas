{% from "apache/map.jinja" import apache with context %}

apache.modules.fastcgi:
  pkg:
    - installed
    - name: {{ apache.modules.fastcgi }}
    - require:
      - pkg: apache.core
