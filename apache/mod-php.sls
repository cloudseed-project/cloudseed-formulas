{% from "apache/map.jinja" import apache with context %}

{% if grains['os_family']=="Debian" %}
mod-php:
  pkg.installed:
    - name: {{ apache.modules.php }}
    - require:
      - pkg: apache
{% endif %}
