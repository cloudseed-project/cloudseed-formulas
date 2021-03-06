{% from "postgresql/map.jinja" import postgresql with context %}
{% set databases = salt['pillar.get']('postgresql:databases', {}) %}
{% set groups = salt['pillar.get']('postgresql:groups', {}) %}
{% set users = salt['pillar.get']('postgresql:users', {}) %}

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
      #{% for user in users.iterkeys() %}
      #- postgres_user: postgresql.user.{{ user }}
      #{% endfor %}
      #{% for group in groups.iterkeys() %}
      #- postgres_group: postgresql.group.{{ group }}
      #{% endfor %}
      #{% for db in databases.iterkeys() %}
      #- postgres_database: postgresql.db.{{ db }}
      #{% endfor %}

{% for group, value in groups.iteritems() %}
postgresql.group.create.{{ group }}:
  postgres_group.present:
    - name: {{ group }}
    - createdb: {{ value.createdb | d('false') }}
    - createuser: {{ value.createuser | d('false') }}
    - superuser: {{ value.superuser | d('false') }}
    - replication: {{ value.replication | d('false') }}
    - user: postgres
    - require:
      - pkg: postgresql.core
      - service: postgresql.service
{% endfor %}

{% for user, value in users.iteritems() %}
postgresql.user.create.{{ user }}:
  postgres_user.present:
    - name: {{ user }}
    - createdb: {{ value.createdb | d('false') }}
    - createuser: {{ value.createuser | d('false') }}
    - encrypted: {{ value.encrypted | d('false') }}
    - superuser: {{ value.superuser | d('false') }}
    - replication: {{ value.replication | d('false') }}
    - groups: {{ value.groups | d('') }}
    - user: postgres
    - require:
      - pkg: postgresql.core
      - service: postgresql.service
      {% if value.groups|d(False) %}
      {% for each in value.groups.split(',') %}
      - postgres_group: postgresql.group.create.{{ each|trim }}
      {% endfor %}
      {% endif %}
{% endfor %}

{% for db, value in databases.iteritems() %}
postgresql.db.create.{{ db }}:
  postgres_database.present:
    - name: {{ db }}
    - encoding: {{ value.encoding | d('UTF8') }}
    - lc_ctype: {{ value.lc_ctype | d('en_US.UTF8') }}
    - lc_collate: {{ value.lc_collate | d('en_US.UTF8') }}
    - template: {{ value.template | d('template0') }}
    - owner: {{ value.owner }}
    - user: postgres
    - require:
      - pkg: postgresql.core
      - service: postgresql.service
      - postgres_user: postgresql.user.create.{{ value.owner }}
{% endfor %}
