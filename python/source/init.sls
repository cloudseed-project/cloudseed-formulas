{% set version = salt["pillar.get"]("python:version") %}

include:
  - wget
  - build-tools

python.source.install:
  cmd.run:
    - name: wget https://www.python.org/ftp/python/{{ version }}/Python-{{ version }}.tgz && tar -xzf Python-{{ version }}.tgz && cd Python-{{ version }} && ./configure && make && make install
    - unless: python=$(which python) && ret=$($python -c "import platform;print(platform.python_version())") && test {{version}} = $ret
    - require:
      - pkg: wget.core
      - pkg: build-tools.core
