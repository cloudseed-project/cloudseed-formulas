mod-php:
  pkg.installed:
    - name: {{ apache.mod-php }}
    - require:
      - pkg: apache
