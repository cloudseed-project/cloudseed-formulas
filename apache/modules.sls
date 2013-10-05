{% if 'modules' in pillar['apache'] %}
{% for module in pillar['apache']['modules'] %}
include:
  - apache.mod-{{module}}
{% endfor %}
{% endif %}
