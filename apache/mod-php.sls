{% from "apache/map.jinja" import apache with context %}
mod-php:
  pkg.installed:
    - name: {{ apache.modules.php }}
    - require:
      - pkg: apache