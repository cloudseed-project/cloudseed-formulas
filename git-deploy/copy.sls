deploy.stage1:
  file.directory:
    - name: {{ salt['pillar.get']('git-deploy:cwd', '/var/www') }}
    - user: {{ salt['pillar.get']('git-deploy:user', 'git') }}
    - group: {{ salt['pillar.get']('git-deploy:group', 'git') }}
    - makedirs: True

deploy.stage2:
  cmd.run:
    - name: GIT_WORK_TREE={{ salt['pillar.get']('git-deploy:cwd', '/var/www') }} git checkout -f
    - cwd: /var/git
    - require:
      - file: deploy.stage1

deploy.stage3:
  file.directory:
    - name: {{ salt['pillar.get']('git-deploy:cwd', '/var/www') }}
    - user: {{ salt['pillar.get']('git-deploy:user', 'git') }}
    - group: {{ salt['pillar.get']('git-deploy:group', 'git') }}
    - recurse:
        - user
        - group
