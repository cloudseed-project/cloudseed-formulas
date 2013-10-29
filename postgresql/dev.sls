{% from "postgresql/map.jinja" import postgresql with context %}
postgresql.dev:
  pkg:
    - install
    - name: {{ postgresql.package_dev}}
