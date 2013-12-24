# Pillar options:

```yaml
git.deploy:
  /srv/git/project.git: <required>
    deploy_path: /path/to/your/project <required>
    user: <optional>
    group: <optional>
    hooks: <required>
        post-receive: salt://your/deploy/action <required>

    # Your hook is treated as a jinja template.
    # the following variables are passed to that
    # template when it is rendered for your use.
    # Using the example above, you would have access
    # to the following values though these variable
    # names:
    #
    # repo_path: '/srv/git/project.git'
    # deploy_path: '/path/to/your/project'
    # user: <user provided or None>
    # group: <group provided or None>
    # hook: 'post-receive'

```
