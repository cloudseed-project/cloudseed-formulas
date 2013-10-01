# Pillar options:

```yaml
git-deploy:
  sls: git-deploy.copy  # sls file to run on post-receive
  cwd: <optional>
  user: <optional>
  group: <optional>
```

`cwd`, `user` and `group` mainily apply to the default `git-deploy.copy`
post-receive action.

`cwd` represent the directory where your code will be checked out to. The
**GIT_WORK_TREE** will be set to this path using `git-deploy.copy`

`user` and `group` will be the user and group given ownership of that folder
and all of it's files. They default to **git** for both the user and group.
