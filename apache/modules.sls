{% if 'apache' in pillar and 'modules' in pillar['apache'] %} 
{% for module in pillar['apache']['modules'] %}
{% if pillar['apache']['modules'][module] == 'enabled' %}
include:
{% if grains['os_family']=="Redhat" %}
  - apache.devel
{% endif %}
  - apache.mod-{{module}}
{% endif %}
{% endfor %}
{% endif %}
