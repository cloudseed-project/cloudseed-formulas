{% from "postgresql/map.jinja" import postgresql with context %}
postgresql.dev:
  pkg:
    - installed
    - name: {{ postgresql.package_dev}}
