include:
  - git.core



git-deploy.user:
  user.present:
    - require:
      - group: git
    - groups:
      - git

  group.present:
    - system: True

include:
  - git.core

{% for path, value in salt['pillar.get']('git.deploy', {}).iteritems() %}

git.deploy.folder.{{ path }}:
  {% if value.user %}
  - user: {{ value.user }}
  {% endif -%}

  {% if value.group %}
  - group: {{ value.group }}
  {% endif -%}

  - makedirs: True
  - require:
    - git.core

  - watch_in:
    - cmd: git.deploy.bare.{{ path }}

git.deploy.bare.{{ path }}:
  cmd.wait:
  {% if value.user %}
  - user: {{ value.user }}
  {% endif -%}

  {% if value.group %}
  - group: {{ value.group }}
  {% endif -%}

  - name: git init --bare
  - cwd: {{ path }}
  - unless: test -e {{ path }}/config
  - require:
    - file: git.deploy.folder.{{ path }}

{% for hook, file in value.hooks.iteritems() %}
git.deploy.action.{{ path}}.{{ hook }}:
  file.managed:
    - name: {{ path }}/hooks/{{ hook }}
    - source: {{ file }}
    - mode: 755

    {% if value.user -%}
    - user: {{ value.user }}
    {% endif -%}

    {% if value.group %}
    - group: {{ value.group }}
    {% endif -%}

    - require:
      - file: git.deploy.folder.{{ path }}
      - cmd: git.deploy.bare.{{ path }}
{% endfor %}

{% endfor %}

# /var/git:
#   file.directory:
#     - user: {{ salt['pillar.get']('cloudseed:ssh_username', 'ubuntu') }}
#     - group: {{ salt['pillar.get']('cloudseed:ssh_username', 'ubuntu') }}
#     - mode: 755
#     - makedirs: True
#     - recurse:
#       - user
#       - group

#     - require:
#       - pkg: git.core

#     - watch_in:
#       - cmd: git init --bare

# git init --bare:
#   cmd.wait:
#     - cwd: /var/git
#     - unless: test -e /var/git/config
#     - user: {{ salt['pillar.get']('cloudseed:ssh_username', 'ubuntu') }}
#     - group: {{ salt['pillar.get']('cloudseed:ssh_username', 'ubuntu') }}
#     - require:
#       - file: /var/git

# /var/git/hooks/post-receive:
#   file.managed:
#     - source: salt://git-deploy/files/post-receive
#     - template: jinja
#     - user: {{ salt['pillar.get']('cloudseed:ssh_username', 'ubuntu') }}
#     - group: {{ salt['pillar.get']('cloudseed:ssh_username', 'ubuntu') }}
#     - mode: 755

#     - require:
#       - file: /var/git
#       - cmd: git init --bare
