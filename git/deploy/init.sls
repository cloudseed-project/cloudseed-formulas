include:
  - git

{% set data = salt['pillar.get']('git.deploy', {}) %}

{% for path, value in data.iteritems() %}
{% set user = value.user|d(False) %}
{% set group = value.group|d(False) %}

git.deploy.repo.{{ path }}:
  file.directory:
    - name: {{ path }}

    {% if user %}
    - user: {{ user }}
    {% endif -%}

    {% if group %}
    - group: {{ group }}
    {% endif -%}

    - makedirs: true

    - require:
      - pkg: git.core

    - watch_in:
      - cmd: git.deploy.bare.{{ path }}


git.deploy.folder.{{ path }}:
  file.directory:
    - name: {{ value.deploy_path }}
    {% if user %}
    - user: {{ user }}
    {% endif -%}

    {% if group %}
    - group: {{ group }}
    {% endif -%}

    - makedirs: true
    - require:
      - file: git.deploy.repo.{{ path }}


git.deploy.bare.{{ path }}:
  cmd.run:
    - name: git init --bare
    - cwd: {{ path }}

    {% if user %}
    - user: {{ user }}
    {% endif -%}

    {% if group %}
    - group: {{ group }}
    {% endif -%}

    - unless: test -e {{ path }}/config
    - require:
      - file: git.deploy.repo.{{ path }}


{% for hook, source in value.hooks.iteritems() %}
git.deploy.hook.wrapper.{{ path }}.{{ hook }}:
  file.managed:
    - template: jinja
    - name: {{ path }}/hooks/{{ hook }}
    - source: salt://git/deploy/files/wrapper.sh
    - mode: 755
    - defaults:
      hook_path: {{ path }}/hooks
      deploy_path: {{ value.deploy_path }}
      hook_name: {{ hook }}

    {% if user %}
    - user: {{ user }}
    {% endif -%}

    {% if group %}
    - group: {{ group }}
    {% endif -%}

    - require:
      - file: git.deploy.folder.{{ path }}
      - cmd: git.deploy.bare.{{ path }}

git.deploy.hook.action.{{ path }}.{{ hook }}:
  file.managed:
    - template: jinja
    - name: {{ path }}/hooks/{{ hook }}.action
    - source: {{ source }}
    - mode: 755
    {% if 'vars' in value %}
    - defaults:
      {% for k, v in value.get('vars', {}).iteritems() %}
      {{ k }}: {{ v }}
      {% endfor -%}
    {% endif %}

    {% if user %}
    - user: {{ user }}
    {% endif -%}

    {% if group %}
    - group: {{ group }}
    {% endif -%}

    - require:
      - file: git.deploy.hook.wrapper.{{ path }}.{{ hook }}

{% endfor %}


{% endfor %}
