{% from "build-tools/map.jinja" import build_tools with context %}
build-tools.core:
  pkg:
    - installed
    - pkgs:
      {% for each in build_tools.packages %}
      - {{ each }}
      {% endfor %}
