{% from "apache/map.jinja" import apache with context %}
mod-php:
  pkg.installed:
    - name: {{ apache.modphp }}
    - require:
      - pkg: apache