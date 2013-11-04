apache.conf.ports:
  file.managed:
    - name: /etc/apache2/ports.conf
    - source: salt://apache/files/debian.ports.conf
    - template: jinja
    - defaults:
      ports: {{ salt['pillar.get']('apache:ports', [80]) }}
    - watch_in:
      - service: apache.service
