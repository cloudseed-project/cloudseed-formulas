{% from "unzip/map.jinja" import unzip with context %}

unzip.core:
  pkg:
    - installed
    - name: {{ unzip.package }}
