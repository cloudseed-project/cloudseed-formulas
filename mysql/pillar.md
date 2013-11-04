mysql:
  root_password:
  configuration_sources:
    # This section is optional

    conf: <optional>      # Path to my.cnf Defaults to
                          # salt://mysql/files/my.cnf

  basic_configuration:
    # This section is optional
    root_password: <optional>   # Defaults to ''
    listen_address: <optional>  # Defaults to '*'
    port: <optional>            # Defaults to 3306

  users:
    <user_name_1>:
      password: <required>
      hosts:
        - localhost
        - %

    <user_name_2>:
      password: <required>
      hosts:
        - localhost
        - %

  databases:
    <db_name_1>:
      owner: <required> # should match a username you have defined above
      character_set: <optional> # Default utf8
      collate: <optional> # Default utf8_general_ci

    <db_name_2>:
      owner: <required> # should match a username you have defined above
      character_set: <optional> # Default utf8
      collate: <optional> # Default utf8_general_ci
