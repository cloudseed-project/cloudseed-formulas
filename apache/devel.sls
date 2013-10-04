{% if grains['os_family']=="Redhat" %}
devel:
  pkg.installed:
    - name: httpd-devel
    - require:
      - pkg: apache
{% endif %}
