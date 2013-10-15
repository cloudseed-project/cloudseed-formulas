{% if 'apache' in pillar and 'modules' in pillar['apache'] %}
{% for module in pillar['apache']['modules'] %}
include:
  - apache.modules.{{module}}
{% endfor %}
{% endif %}
