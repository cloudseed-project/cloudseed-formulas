{% from "curl/map.jinja" import curl with context %}
curl:
  pkg:
    - installed
    - name: {{ curl.package }}
