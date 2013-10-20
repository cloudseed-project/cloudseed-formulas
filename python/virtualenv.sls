include:
  - python

python.virtualenv:
  pip:
    - installed
    - name: virtualenv
    - require:
      - pkg: python.pip
