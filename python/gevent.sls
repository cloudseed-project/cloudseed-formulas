{% from "python/map.jinja" import python with context %}

include:
  - python.virtualenv

python.libevent:
  pkg:
    - installed
    - name: {{ python.libevent_dev }}

python.gevent:
  pip:
    - installed
    - bin_env: test-env
    - require:
      - virtualenv: test-env
      - pkg: libevent
