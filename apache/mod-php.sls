{% from "apache/map.jinja" import apache with context %}
mod-php:
  pkg.installed:
    - name: libapache2-mod-php5
    - require:
      - pkg: apache