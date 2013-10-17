{% from "build_tools/map.jinja" import build_tools with context %}
build_tools:
  {{ build_tools.action }}:
    - installed
    - name: {{ build_tools.package }}
