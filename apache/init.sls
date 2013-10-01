apache:
  pkg.installed:
  {% if grains['os'] == 'RedHat' %}
    - name: httpd
  service:
  - name: httpd
  - running
  {% elif grains['os'] == 'Ubuntu' %}
    - name: apache2
  service:
  - name: apache2
  - running
  {% endif %}
