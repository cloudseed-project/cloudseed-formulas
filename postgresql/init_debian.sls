{% set version = salt['cmd.run']("VERSION=$(psql --version | sed -E s/[^0-9\.]*//g | tr -d '\n') && echo ${VERSION:0:3}", require=[{'pkg': 'postgresql.core'}]) %}
foo:
  file.mamaged:

postgresql.debian.conf:
  cmd.run:
    - name: >
              VERSION=$(psql --version | sed -E s/[^0-9\.]*//g | tr -d '\n') &&
              mv /etc/postgresql/${VERSION:0:3}/main/*.conf {{ postgresql.data_dir }}

    - onlyif: >
                VERSION=$(psql --version | sed -E s/[^0-9\.]*//g | tr -d '\n') &&
                ls -1 /etc/postgresql/${VERSION:0:3}/main/ | grep '\.conf$'
    - shell: /bin/bash
    - require:
      - pkg: postgresql.core
      - file: postgresql.data_dir
    - watch_in:
      - service: postgresql.service
