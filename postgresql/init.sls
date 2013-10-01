postgresql:
  pkg:
    - installed
    - name: postgresql-{{ pillar['postgresql']['version'] }}
  service:
    - name: postgresql
    - running
    - enable: True
    - require:
      - pkg: postgresql

{% for db, value in pillar['postgresql']['databases'].iteritems() %}
postgresql.user.{{ value.user }}:
  postgres_user.present:
    - name: {{ value.user }}
    - password: {{ value.password }}
    - encrypted: True
    - runas: postgres
    - require:
      - service: postgresql

postgresql.db.{{ db }}:
  postgres_database.present:
    - name: {{ db }}
    - encoding: {{ value.encoding | d('UTF8') }}
    - lc_ctype: {{ value.lc_ctype | d('en_US.UTF8') }}
    - lc_collate: {{ value.lc_collate | d('en_US.UTF8') }}
    - template: {{ value.template | d('template0') }}
    - owner: {{ value.user }}
    - runas: postgres
    - require:
      - postgres_user: postgresql.user.{{ value.user }}
{% endfor %}

postgresql.hba:
  file.managed:
      - name: /etc/postgresql/{{ pillar['postgresql']['version'] }}/main/pg_hba.conf
      - source: salt://postgresql/files/pg_hba.conf
      - user: postgres
      - group: postgres
      - template: jinja
      - mode: 644
      - require:
          - pkg: postgresql
      - watch_in:
        - service: postgresql


postgresql.conf:
  file.managed:
      - name: /etc/postgresql/{{ pillar['postgresql']['version'] }}/main/postgresql.conf
      - source: {{ pillar['postgresql']['conf'] | d('salt://postgresql/files/postgresql.conf') }}
      - user: postgres
      - group: postgres
      - template: jinja
      - mode: 644
      - require:
          - pkg: postgresql
      - watch_in:
        - service: postgresql
