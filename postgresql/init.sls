{% from "postgresql/map.jinja" import postgresql with context %}
{% set databases = salt['pillar.get']('postgresql:databases', {}) %}

include:
{% if grains['os_family'] == 'Debian' %}
 - postgresql.debian
{% elif grains['os_family'] == 'RedHat' %}
 - postgresql.redhat
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


{% for db, value in databases.iteritems() %}
postgresql.user.{{ value.user }}:
  postgres_user.present:
    - name: {{ value.user }}
    - password: {{ value.password }}
    - encrypted: True
    - user: postgres
    - require:
      - service: postgresql.service

postgresql.db.{{ db }}:
  postgres_database.present:
    - name: {{ db }}
    - encoding: {{ value.encoding | d('UTF8') }}
    - lc_ctype: {{ value.lc_ctype | d('en_US.UTF8') }}
    - lc_collate: {{ value.lc_collate | d('en_US.UTF8') }}
    - template: {{ value.template | d('template0') }}
    - owner: {{ value.user }}
    - user: postgres
    - require:
      - postgres_user: postgresql.user.{{ value.user }}
{% endfor %}
