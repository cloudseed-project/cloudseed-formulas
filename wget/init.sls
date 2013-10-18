{% from "wget/map.jinja" import wget with context %}

wget.core:
  pkg:
    - installed
    - name: {{ wget.package }}
