# Pillar options:

```yaml
mysql:
  root_password: <password>
  databases:
    <db_name_1>:
      user: <username>
      password: <password>
      host: <optional>  # Default %
      grant: <optional>  # Defaults to ALL PRIVILEGES

    <db_name_2>:
      user: <username>
      password: <password>
      host: <optional>
      grant: <optional>
```

This does not require the MySQLdb Python module to execute.
It uses some simple command line calls to do it's work.
