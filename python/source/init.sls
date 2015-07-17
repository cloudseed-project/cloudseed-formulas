{% set version = salt["pillar.get"]("python:version") %}

include:
  - wget

python.source.install:
  cmd.run:
    - name |
      wget https://www.python.org/ftp/python/{{ version }}/Python-{{ version }}.tgz &&\
      tar -xzf Python-{{ version }}.tgz && cd Python-{{ version }} &&\
      ./configure && make && make install
    - require:
      - pkg: wget.core
