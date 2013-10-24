{% from "postgresql/map.jinja" import postgresql with context %}

{% if grains['os_family'] == 'Debian' %}
include:
 - postgresql.debian
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


{% if grains['os_family'] == 'RedHat' %}
{% include 'postgresql/redhat/init.sls' with context %}
{% endif %}
