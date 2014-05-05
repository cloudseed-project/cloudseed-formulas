{% from "supervisor/map.jinja" import supervisor with context %}
{% set groups = salt['pillar.get']('supervisor:groups', {}) %}
{% set programs = salt['pillar.get']('supervisor:programs', {}) %}

supervisor.core:
    pkg:
    - installed
    - name: {{ supervisor.package }}

supervisor.service:
  service:
    - running
    - name: supervisor
    - enable: True
    - require:
      - pkg: supervisor.core

{% for name, values in groups.iteritems() %}
supervisor.group.{{ name }}:
  file.managed:
  - name: //etc/supervisor/conf.d/group_{{ name }}.conf
  - source: {{ values.conf|d('salt://supervisor/files/group.conf') }}
  - template: jinja
  - defaults:
      name: {{ name }}
      values: {{ values }}
  - watch_in:
    - service: supervisor.service
{% endfor %}

{% for name, values in programs.iteritems() %}
supervisor.program.{{ name }}:
  file.managed:
  - name: /etc/supervisor/conf.d/program_{{ name }}.conf
  - source: {{ values.conf|d('salt://supervisor/files/program.conf') }}
  - template: jinja
  - defaults:
      name: {{ name }}
      values: {{ values }}
  - watch_in:
    - service: supervisor.service
{% endfor %}
