{% from "curl/map.jinja" import curl with context %}

curl.core:
  pkg:
    - installed
    - name: {{ curl.package }}
