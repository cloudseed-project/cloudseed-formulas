{% if 'modules' in pillar['apache'] %} 
{% for module in pillar['apache']['modules'] %}
include:
{% if grains['os_family']=="Redhat" %}
  - apache.devel
{% endif %}
  - apache.mod-{{module}}
{% endfor %}
{% endif %}
