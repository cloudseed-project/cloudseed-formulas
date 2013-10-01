git:
  pkg.installed:
  {% if grains['os'] == 'RedHat' or grains['os'] == 'Fedora' or grains['os'] == 'CentOS'%}
    - name: git-core
  {% elif grains['os'] == 'Debian' or grains['os'] == 'Ubuntu'%}
    - name: git
  {% endif %}

  user.present:
    - require:
      - group: git

    - groups:
      - git

  group.present:
    - system: True


/var/git:
  file.directory:
    - user: {{ salt['pillar.get']('cloudseed:ssh_username', 'ubuntu') }}
    - group: {{ salt['pillar.get']('cloudseed:ssh_username', 'ubuntu') }}
    - mode: 755
    - makedirs: True
    - recurse:
      - user
      - group

    - require:
      - pkg: git

    - watch_in:
      - cmd: git init --bare

git init --bare:
  cmd.wait:
    - cwd: /var/git
    - unless: test -e /var/git/config
    - user: {{ salt['pillar.get']('cloudseed:ssh_username', 'ubuntu') }}
    - group: {{ salt['pillar.get']('cloudseed:ssh_username', 'ubuntu') }}
    - require:
      - file: /var/git

/var/git/hooks/post-receive:
  file.managed:
    - source: salt://git-deploy/files/post-receive
    - template: jinja
    - user: {{ salt['pillar.get']('cloudseed:ssh_username', 'ubuntu') }}
    - group: {{ salt['pillar.get']('cloudseed:ssh_username', 'ubuntu') }}
    - mode: 755

    - require:
      - file: /var/git
      - cmd: git init --bare
