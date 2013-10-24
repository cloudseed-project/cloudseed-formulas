postgreql.redhat.sysconfig:
  file.managed:
    - name: /etc/sysconfig/pgsql/postgresql
    - watch_in:
      - service: postgresql.service
