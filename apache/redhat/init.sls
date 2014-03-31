apache.conf.ports:
  file.managed:
    - name: /etc/httpd/ports.conf
    - source: salt://apache/files/redhat.ports.conf
    - template: jinja
    - defaults:
      ports: {{ salt['pillar.get']('apache:ports', [80]) }}
    - watch_in:
      - service: apache.service
