{% from "mysql/map.jinja" import mysql with context %}
{% set root_password = salt['pillar.get']('mysql:basic_configuration:root_password', False) %}
{% set cli_password = "-p'%s'"|format(root_password) if root_password else '' %}
{% set databases = salt['pillar.get']('mysql:databases', {}) %}
{% set users = salt['pillar.get']('mysql:users', {}) %}


mysql.core:
  pkg:
    - installed
    - pkgs:
      - {{ mysql.package_server }}
      {% if mysql.package_client|d(False) -%}
      - {{ mysql.package_client }}
      {% endif %}

mysql.service:
  service:
    - running
    - name: {{ mysql.service }}
    - enable: True
    - require:
      - pkg: mysql.core


mysql.root.password:
  cmd.run:
    - name: mysqladmin -uroot password '{{ root_password|d('', True) }}'
    - unless: mysqladmin -uroot {{ cli_password }} status > /dev/null
    - require:
      - pkg: mysql.core
      - file: mysql.config

{% for db, value in databases.iteritems() %}
mysql.db.{{ db }}:
  cmd.run:
    - name: mysql -uroot {{ cli_password }} -e "CREATE DATABASE {{ db }} CHARACTER SET {{ value.character_set | d('utf8') }} COLLATE {{ value.collate | d('utf8_general_ci') }};"
    - unless: mysql -uroot {{ cli_password }} -e "use {{ db }}"
    - require:
      - pkg: mysql.core
      - cmd: mysql.root.password
{% endfor %}

{% for user, value in user.iteritems() %}
mysql.db.{{ db }}:
  cmd.run:
    - name: mysql -uroot {{ cli_password }} -e "CREATE DATABASE {{ db }} CHARACTER SET {{ value.character_set | d('utf8') }} COLLATE {{ value.collate | d('utf8_general_ci') }};"
    - unless: mysql -uroot {{ cli_password }} -e "use {{ db }}"
    - require:
      - pkg: mysql.core
      - cmd: mysql.root.password
{% endfor %}

# {% if grains['os'] in ['Ubuntu', 'Debian', 'Gentoo'] %}
# my.cnf:
#   file.managed:
#     - name: {{ mysql.config }}
#     - source: salt://mysql/files/{{ grains['os'] }}-my.cnf
#     - user: root
#     - group: root
#     - mode: 644
#     - template: jinja
#     - watch_in:
#       - service: {{ mysql.service }}
# {% endif %}
