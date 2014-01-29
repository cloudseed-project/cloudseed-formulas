# Pillar options:

```yaml
solr:
  configuration_sources:
    jetty: <optional>       # Path to jetty.xml Defaults to
                            # salt://solr/files/jetty.xml

    webdefault: <optional>  # Path to jetty.xml Defaults to
                            # salt://solr/files/webdefault.xml

  configuration_locations:
    install_location: <optional>  # Path to install Solr into
                                  # Defaults to /srv/solr

  basic_configuration:
    # This section is optional
    listen_address: <optional>  # Defaults to '0.0.0.0'
    port: <optional>            # Defaults to 8983
    authentication: <optional>  # Defaults to false

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
