{% set version = salt['pillar.get']('java:version', 'v6') %}
{% set vendor = salt['pillar.get']('java:vendor', 'openjdk') %}

include:
  - java.{{vendor}}{{version}}
