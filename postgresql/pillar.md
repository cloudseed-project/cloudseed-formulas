# Pillar options:

```yaml
postgresql:

  configuration_sources:
    # This section is optional

    conf: <optional>      # Path to postgresql.conf Defaults to
                          # salt://postgresql/files/postgresql.conf

    pg_hba: <optional>    # Path to pg_hba.conf Defaults to
                          # salt://postgresql/files/pg_hba.conf

    pg_ctl: <optional>    # Path to pg_ctl.conf Defaults to
                          # salt://postgresql/files/pg_ctl.conf

    pg_ident: <optional>  # Path to pg_ident.conf Defaults to
                          # salt://postgresql/files/pg_ident.conf

    sysconfig: <optional> # On RedHat based systems, the path to what will become
                        # /etc/sysconfig/pgsql/postgresql Defaults to
                        # salt://postgresql/files/postgresql-sysconfig.conf

  configuration_locations:
    # This section is optional

    # It defines basic parameters to use when rendering the postgresql.conf
    # file. For advanced configuration, please provide your own postgresql.conf.
    # Note, if you are handing it your own conf file, you can probably ignore
    # these, however they will be available to you when your conf file renders.
    #
    # WARNING
    # there is some nuance here between RedHat and Debian. For example,
    # the stock Debian install ignores PGDATA in favor of always looking at
    # /etc/postgresql/{{ version }}/main/postgresql.conf for it's configuration.
    # On RedHat, however, it will obey PGDATA. By default, Postgres assumes that
    # your PGDATA dir also contains your postgresql.conf file.
    # See this section in the docs for more details:
    #
    # http://www.postgresql.org/docs/9.1/static/runtime-config-file-locations.html
    #
    # Specifically this paragraph:
    # If you wish to keep the configuration files elsewhere than the data
    # directory, the postgres -D command-line option or PGDATA environment
    # variable must point to the directory containing the configuration
    # files, and the data_directory parameter must be set in postgresql.conf
    # (or on the command line) to show where the data directory is actually
    # located. Notice that data_directory overrides -D and PGDATA for the
    # location of the data directory, but not for the location of the
    # configuration files.

    pgdata: <optional>                # Debian: not used
                                      # RedHat: /var/lib/pgsql/data

    data_directory: <optional>        # Debian: /var/lib/postgresql/{{ version }}/main
                                      # RedHat: {{ pgdata }}

    unix_socket_directory: <optional> # Debian: /var/run/postgresql
                                      # RedHat: /var/run/postgresql

    sysconfig_location: <optional>    # Debian: not used
                                      # Redhat: /etc/sysconfig/pgsql/postgresql

    postgresql_location: <optional>   # Debian: /etc/postgresql/{{ version }}/main/postgresql.conf
                                      # Redhat: {{ pgdata }}/postgresql.conf

    hba_location: <optional>          # Debian: /etc/postgresql/{{ version }}/main/pg_hba.conf
                                      # RedHat: {{ pgdata }}/pg_hba.conf

    ident_location: <optional>        # Debian: /etc/postgresql/{{ version }}/main/pg_ident.conf
                                      # RedHat: {{ pgdata }}/pg_ident.conf

    ctl_location: <optional>          # Debian: /etc/postgresql/{{ version }}/main/pg_ctl.conf
                                      # RedHat: {{ pgdata }}/pg_ctl.conf

  basic_configuration:
    # This section is optional

    listen_address: <optoinal>  # Defaults to '*'
    port: <optional>            # Defaults to 5432


  # Databases and Users
  databases:
    # This section is optional
    # (you probably want databases though)

    <db_name_1>:
      user: <username>
      password: <password>
      encoding: <optional> # Default UTF8
      lc_ctype: <optional> # Default en_US.UTF8
      lc_collate: <optional> # Default en_US.UTF8
      template: <optional> # Default template0

    <db_name_2>:
      user: <username>
      password: <password>
      encoding: <optional> # Default UTF8
      lc_ctype: <optional> # Default en_US.UTF8
      lc_collate: <optional> # Default en_US.UTF8
      template: <optional> # Default template0

  # Host Baseed Authentication Settings
  hba:
    # This section is optional
    # (you probably want authentication setting though)

    - type: <host>
      database: <database_name>
      user: <username>
      address: <address>
      method: <method>

    # Example IPv4:
    - type: host
      database: my_database
      user: vagrant
      address: 0.0.0.0/0
      method: md5
```
