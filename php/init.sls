{% from "php/map.jinja" import php with context %}

php.core:
  pkg:
    - installed
    - name: {{ php.package }}

php.cli.core:
  pkg:
    - installed
    - name: {{ php.package_cli }}

php.pear.core:
  pkg:
    - installed
    - name: {{ php.package_pear }}
    - require:
      - pkg: php.core
      - pkg: php.cli.core
