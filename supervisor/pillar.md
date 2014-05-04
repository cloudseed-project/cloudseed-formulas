# Pillar options:

```yaml
supervisor:
    groups:  <optional>                  # You may optionally define program
                                         # groups. Each group may contain
                                         # the available directives defined here:
                                         # http://supervisord.org/configuration.html#group-x-section-settings
                                         #
                                         # Note that YAML lists will be joined with ',' in the final
                                         # output
                                         #
      group_name_1:                      # The name of the group must be defined
                                         #
        conf:                            # Defaults to salt://supervisor/files/group.conf
                                         #
        programs: <required>             # If using groups a set of programs
          - foo                          # must be defined that represent this
          - bar                          # group.
          - baz                          #
                                         #
        priority: 999 <optional>         # Optional priority for the group
                                         #
    programs: <optional>                 # Programs are optional, but if you do
                                         # not define any, using supervisor is
                                         # effectively pointless.
                                         #
      program_name_1:                    # The name of the program. This name
                                         # is the name that would be used in
                                         # the groups above. Each program may
                                         # contain the available directives
                                         # defined here:
                                         # http://supervisord.org/configuration.html#group-x-section-settings
                                         #
                                         # Note that YAML lists will be joined with ',' in the final
                                         # output. What follows are just some of the options
                                         # you can choose to include. Please review the link
                                         # above for more options to include.
                                         #
        conf:                            # Defaults to salt://supervisor/files/program.conf
                                         #
        command: <required>              # The command that you would like to run
                                         #
        user: <optional>                 # The user to run this command as
                                         #
        environment: <optional>          # A list of environment variables to set
          - PATH: /usr/bin               # Note that this will convert into KEY1="VALUE1", KEY2="VALUE2"
          - PYTHONPATH: /foo/bar         #
                                         #
        directory: <optional>            # The directory to change to prior to running the command
                                         #
        autostart: <optional>            # Defaults to true
                                         #
        autorestart: <optional>          # Defaults to unexpected
```
