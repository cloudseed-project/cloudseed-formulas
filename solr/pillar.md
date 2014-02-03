# Pillar options:

```yaml
solr:
  version: <optional>       # Defaults to 4.6.1

  java:
    # This section is optional
    initial_heap: <optional>  # Defaults to 128M
    maximum_heap: <optional>  # Defaults to 256M

  configuration_sources:
    # This section is optional
    jetty: <optional>       # Path to jetty.xml Defaults to
                            # salt://solr/files/jetty.xml

    webdefault: <optional>  # Path to jetty.xml Defaults to
                            # salt://solr/files/webdefault.xml

  configuration_locations:
    # This section is optional
    install_location: <optional>  # Path to install Solr into
                                  # Defaults to /srv/solr

  basic_configuration:
    # This section is optional
    listen_address: <optional>  # Defaults to '0.0.0.0'
    port: <optional>            # Defaults to 8983

  basic_authentication:
    # This section is optional
    realm: Test Realm
    users:
      guest:
        password: guest
        roles:
          - core1-role
          - core2-role
          - core3-role
      foo:
        password: foo
        roles:
          - core1-role

    resources:
      Everything:
        pattern: /
        roles:
         - core1-role
         - core2-role

```
