{% from "mysql/map.jinja" import mysql with context %}
mysql.dev:
  pkg:
    - installed
    - name: {{ mysql.package_dev}}
