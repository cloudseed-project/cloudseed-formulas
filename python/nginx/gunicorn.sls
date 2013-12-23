include:
  - python
  - nginx
  {% if grains['os_family'] == 'Debian' %}
  - python.nginx.debian.gunicorn
  {% endif %}

python.nginx.gunicorn.core:
  pip:
    - installed
    - name: gunicorn
    {% if salt['pillar.get']('python:env_path', False) %}
    - bin_env: {{  salt['pillar.get']('python:env_path', False) }}
    {% endif %}
