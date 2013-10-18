{% from "rabbitmq/map.jinja" import rabbitmq with context %}

rabbitmq.core:
    pkg:
    - installed
    - name: {{ rabbitmq.package }}

rabbitmq.service:
  service:
    - running
    - name: {{ rabbitmq.service }}
    - enable: True
    - watch:
      - pkg: {{ rabbitmq.package }}
      - file: rabbitmq.config
      - file: rabbitmq.env


rabbitmq.dir.conf:
  file.directory:
    - name: /etc/rabbitmq/rabbitmq.conf.d
    - user: root
    - group: root
    - mode: 655
    - makedirs: True
    - require:
      - pkg: rabbitmq.core

rabbitmq.env:
  file.managed:
    - name: {{ rabbitmq.env }}
    - source: "{{ pillar.get('rabitmq')['env']|d('salt://rabbitmq/files/rabbitmq-env.conf') }}"
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: rabbitmq.core
      - file: rabbitmq.dir.conf

rabbitmq.config:
  file.managed:
    - name: {{ rabbitmq.config }}
    - source: "{{ pillar.get('rabitmq')['conf']|d('salt://rabbitmq/files/rabbitmq.config') }}"
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: rabbitmq.core
      - file: rabbitmq.dir.conf
