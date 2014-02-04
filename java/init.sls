{% set version = salt['pillar.get']('java:version', 6) %}
{% set vendor = salt['pillar.get']('java:vendor', 'openjdk') %}

include:
  - java.{{vendor}}{{version}}
