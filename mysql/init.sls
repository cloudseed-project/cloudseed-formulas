{% set root_password = salt['pillar.get']('mysql:root_password', False) %}
{% set cli_password = "-p'%s'"|format(root_password) if root_password else '' %}

mysql-server:
  pkg:
    - installed
  service:
    - name: mysql
    - running
    - enable: True
    - require:
      - pkg: mysql-server

mysql.config:
  file.managed:
    - name: /etc/mysql/my.cnf
    - source: salt://mysql/files/my.cnf
    - user: root
    - group: root
    - mode: 644
    - template: jinja

    - watch_in:
      - service: mysql-server

    - require:
        - pkg: mysql-server

mysql.admin:
  cmd.run:
    - name: mysqladmin -uroot password '{{ root_password|d('', True) }}'
    - unless: mysqladmin -uroot {{ cli_password }} status > /dev/null
    - require:
      - pkg: mysql-server
      - file: mysql.config


{% for db, value in salt['pillar.get']('mysql:databases', {}).iteritems() %}

mysql.database.{{ db }}:
  cmd.run:
    - name: mysql -uroot {{ cli_password }} -e "CREATE DATABASE {{ db }};"
    - unless: mysql -uroot {{ cli_password }} -e "use {{ db }}"
    - require:
      - cmd: mysql.admin

mysql.user.{{ value.user }}.localhost:
  cmd.wait:
    - name: mysql -uroot {{ cli_password }} -e "CREATE USER '{{ value.user }}'@'{{ value.host|default('localhost') }}' IDENTIFIED BY '{{ value.password|default('') }}';"
    - unless: mysql -u{{ value.user }} -p'{{ value.password|default('') }}' -e "SELECT 1;"
    - watch:
      - cmd: mysql.database.{{ db }}

mysql.grant.{{ db }}.{{ value.user }}.localhost:
  cmd.wait:
    - name: mysql -uroot {{ cli_password }} -e "GRANT {{ value.grant|default('ALL PRIVILEGES') }} ON {{ db }} . * TO '{{ value.user }}'@'{{ value.host|default('localhost') }}';"
    - watch:
      - cmd: mysql.user.{{ value.user }}.localhost

mysql.user.{{ value.user }}:
  cmd.wait:
    - name: mysql -uroot {{ cli_password }} -e "CREATE USER '{{ value.user }}'@'{{ value.host|default('%') }}' IDENTIFIED BY '{{ value.password|default('') }}';"
    - watch:
      - cmd: mysql.user.{{ value.user }}.localhost

mysql.grant.{{ db }}.{{ value.user }}:
  cmd.wait:
    - name: mysql -uroot {{ cli_password }} -e "GRANT {{ value.grant|default('ALL PRIVILEGES') }} ON {{ db }} . * TO '{{ value.user }}'@'{{ value.host|default('%') }}';"
    - watch:
      - cmd: mysql.user.{{ value.user }}

{% endfor %}
