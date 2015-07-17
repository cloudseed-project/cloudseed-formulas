{% from "python/map.jinja" import python with context %}
{% set version = salt["pillar.get"]("python:version") %}

include:
  - wget
  - build-tools
  - openssl # need libssl-dev for --with-ensurepip=install
            # in python.source.install

# https://github.com/saltstack/salt/issues/7659#issuecomment-71106735
# in order for salt's pip states to run we need a system wide pip
# install

python.source.system.pip:
  pkg:
    - installed
    - name: {{ python.pip }}

python.source.install:
  cmd.run:
    - name: cd /tmp && wget https://www.python.org/ftp/python/{{ version }}/Python-{{ version }}.tgz && tar -xzf Python-{{ version }}.tgz && cd Python-{{ version }} && ./configure --with-ensurepip=install && make && make install
    - unless: python=$(which python) && ret=$($python -c "import platform;print(platform.python_version())") && test {{version}} = $ret
    - require:
      - pkg: wget.core
      - pkg: build-tools.core
      - pkg: openssl.dev
      - pkg: python.source.system.pip

python.source.cleanup:
  cmd.wait:
    - name: cd /tmp && rm -rf Python-{{ version }} && rm -f  Python-{{ version }}.tgz
    - watch:
      - cmd: python.source.install
