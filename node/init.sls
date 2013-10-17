# {% from "php/map.jinja" import php with context %}

include:
  - build_tools
  - curl

node:
  cmd.run:
    - name: ls
    - require:
      - pkg: build_tools
      - pkg: curl
