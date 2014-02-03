{% from "java/oracle_map.jinja" import oracle with context %}

# WARNING THIS IS ALL UBUNTU SPECIFIC

include:
  - java.oracle_ubuntu

java.core:
  pkg:
    - installed
    - name: {{ oracle.package.v6 }}
    - require:
      - pkgrepo: oracle.ubuntu.ppa
      - cmd: oracle.ubuntu.license.1
      - cmd: oracle.ubuntu.license.2
