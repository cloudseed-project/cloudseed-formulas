{% from "apache/map.jinja" import apache with context %}

mod-fastcgi:
  pkg:
    - installed
    - name: {{ apache.modules.fastcgi }}
    - require:
      - pkg: apache
