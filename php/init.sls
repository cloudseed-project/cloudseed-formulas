{% from "php/map.jinja" import php with context %}

php:
  pkg:
    - installed
    - name: {{ php.package }}