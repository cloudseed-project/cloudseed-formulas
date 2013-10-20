{% from "ruby/map.jinja" import ruby with context %}

ruby.core:
  pkg:
    - installed
    - name: {{ ruby.package }}

ruby.gem:
  pkg:
    - installed
    - name: {{ ruby.gem }}
    - require:
      - pkg: ruby.core
      - pkg: ruby.dev

ruby.dev:
  pkg:
    - installed
    - name: {{ ruby.dev }}
    - require:
      - pkg: ruby.core
