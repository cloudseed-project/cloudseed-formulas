{% from "mysql/map.jinja" import mysql with context %}
{% set root_password = salt['pillar.get']('mysql:basic_configuration:root_password', False) %}
{% set databases     = salt['pillar.get']('mysql:databases', {}) %}
{% set users         = salt['pillar.get']('mysql:users', {}) %}
{% set grants        = salt['pillar.get']('mysql:grants', []) %}
{% set port          = salt['pillar.get']('mysql:basic_configuration:port', 3306) %}
{% set cli_password  = "-p'%s'"|format(root_password) if root_password else '' %}
{% set username      = 'root' %}


mysql.core:
  pkg:
    - installed
    - pkgs:
      - {{ mysql.package_server }}
      {% if mysql.package_client|d(False) -%}
      - {{ mysql.package_client }}
      {% endif %}

mysql.salt.support:
  pkg:
    - installed
    - pkgs:
    {% for each in mysql.python %}
      - {{ each }}
    {% endfor %}
    - require:
      - pkg: mysql.core

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

{% for user, value in users.iteritems() %}
{% for each in value %}
mysql.user.{{ user }}.{{ each.host }}:
  cmd.run:
    - name: mysql -uroot {{ cli_password }} -e "CREATE USER '{{ user }}'@'{{ each.host|d('localhost') }}' IDENTIFIED BY '{{ each.password|d('') }}';"
    - unless: mysql -u root {{ cli_password }} -D mysql -N -B -e "SELECT CONCAT(user, '@', host) from user;" | grep {{ user }}@{{ each.host|d('localhost') }}
    - require:
      - pkg: mysql.core
      - cmd: mysql.root.password
{% endfor %}
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

{% for each in grants %}
mysql.grant.{{ each.user }}.{{ each.host }}:
  mysql_grants.present:
    - grant: {{ each.grant }}
    - database: {{ each.database }}
    - user: {{ each.user }}
    - host: '{{ each.host|d('localhost') }}'
    - grant_option: false
    - escape: true
    - revoke_first: false
    - mysql.host: 'localhost'
    - mysql.port: {{ port }}
    - mysql.user: {{ username }}
    - mysql.pass: {{ root_password }}
    - mysql.db: 'mysql'
    - require:
      - pkg: mysql.core
      - pkg: mysql.salt.support
      - cmd: mysql.root.password
      - cmd: mysql.db.{{ each.database.split('.')[0] }}
      - cmd: mysql.user.{{ each.user }}.{{ each.host|d('localhost') }}
{% endfor %}
