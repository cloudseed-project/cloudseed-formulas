# Pillar options:

```yaml
postgresql:
  version: 9.1 # required
  conf: <optional> # Path to postgresql.conf Defaults to salt://postgresql/files/postgresql.conf

  # Databases and Users
  databases:
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
