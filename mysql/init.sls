{% from "mysql/map.jinja" import mysql with context %}
{% set root_password = salt['pillar.get']('mysql:basic_configuration:root_password', False) %}
{% set cli_password = "-p'%s'"|format(root_password) if root_password else '' %}
{% set databases = salt['pillar.get']('mysql:databases', {}) %}
{% set users = salt['pillar.get']('mysql:users', {}) %}
{% set grants = salt['pillar.get']('mysql:grants', {}) %}


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

{% for each in grants.iteritems() %}
mysql.grant.{{ each.user }}.{{ each.host }}:
  cmd.run:
    - name: mysql -uroot {{ cli_password }} -e "GRANT {{ each.grant|d('ALL PRIVILEGES') }} ON {{ each.database }} TO '{{ each.user }}'@'{{ each.host|d('localhost') }}';"
    - require:
      - pkg: mysql.core
      - cmd: mysql.root.password
      - cmd: mysql.user.{{ each.user }}.{{ each.host|d('localhost') }}
      - cmd: mysql.db.{{ each.database.split('.')[0] }}
{% endfor %}

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
{% for each in value %}
mysql.user.{{ user }}.{{ each.host }}:
  cmd.run:
    - name: mysql -uroot {{ cli_password }} -e "CREATE USER '{{ user }}'@'{{ each.host }}' IDENTIFIED BY '{{ each.password|default('') }}';"
    - unless: mysql -u{{ user }} -p'{{ each.password|default('') }}' -e "SELECT 1;"
    - require:
      - pkg: mysql.core
      - cmd: mysql.root.password
{% endfor %}
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
