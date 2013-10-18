{% from "python/map.jinja" import python with context %}

python.core:
  pkg:
    - installed
    - name: {{ python.python }}

python.pip:
  pkg:
    - installed
    - name: {{ python.pip }}
    - require:
      - pkg: python.core
      - pkg: python.dev

python.dev:
  pkg:
    - installed
    - name: {{ python.dev }}
    - require:
      - pkg: python.core