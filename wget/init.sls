{% from "wget/map.jinja" import wget with context %}

wget:
  pkg:
    - installed
    - name: {{ wget.package }}
