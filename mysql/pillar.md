mysql:

  configuration_sources:
    # This section is optional

    conf: <optional>      # Path to my.cnf Defaults to
                          # salt://mysql/files/my.cnf

  configuration_locations:
    # This section is optional

    unix_socket_directory: <optional>  # Debian: /var/run/mysqld

    my_cnf_location: <optional>   # Debian: /etc/mysql/my.cnf
                                  # Redhat: /etc/mysql/my.cnf

  basic_configuration:
    # This section is optional
    root_password: <optional>   # Defaults to ''
    listen_address: <optional>  # Defaults to '127.0.0.1'
    port: <optional>            # Defaults to 3306

  grants:
    - user: <user_name_1>
      host: localhost           # Defaults to localhost
      grant: select,insert,update
      database: exampledb.*

    - user: <user_name_1>
      host: %                   # Defaults to localhost
      grant: all privileges
      database: exampledb.*

  users:
    <user_name_1>:
      - host: localhost
        password: 123456

      - host: %
        password: 123456

    <user_name_2>:
      - host: localhost
        password: 123456

      - host: %
        password: 123456

  databases:
    <db_name_1>:
      character_set: <optional> # Default utf8
      collate: <optional> # Default utf8_general_ci

    <db_name_2>:
      character_set: <optional> # Default utf8
      collate: <optional> # Default utf8_general_ci
