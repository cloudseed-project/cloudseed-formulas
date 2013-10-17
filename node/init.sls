# {% from "php/map.jinja" import php with context %}

include:
  - build-tools
  - curl

node:
  cmd.run:
    - name: ls
    - require:
      - pkg: build-tools
      - pkg: curl
