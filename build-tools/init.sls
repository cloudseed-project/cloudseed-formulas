{% from "build-tools/map.jinja" import build_tools with context %}
build-tools:
  pkg:
    - {{ build_tools.action }}
    - name: {{ build_tools.package }}
