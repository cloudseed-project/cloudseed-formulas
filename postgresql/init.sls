{% from "postgresql/map.jinja" import postgresql with context %}
include:
  {% if grains['os_family'] == 'Debian' %}
 - postgresql.init_debian_conf
 - postgresql.init_debian_hba
  {% endif %}

postgresql.core:
  pkg:
    - installed
    - pkgs:
      - {{ postgresql.package_server }}
      {% if postgresql.package_client|d(False) -%}
      - {{ postgresql.package_client }}
      {% endif %}

postgresql.service:
  service:
    - name: {{ postgresql.service }}
    - running
    - enable: True
    - require:
      - pkg: postgresql.core
