{% from "apache/map.jinja" import apache with context %}

mpm-worker:
  pkg:
    - installed
    - name: {{ apache['mpm-worker'] }}
    - require:
      - pkg: apache

php5-fpm:
  pkg:
    - installed
    - name: php5-fpm
    - require:
      - pkg: mod-fastcgi

/etc/{{ apache.package }}/conf.d/fastcgi-php.conf:
  file.managed:
    - source: salt://apache/modules/php/files/fastcgi-php.conf
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - watch_in:
      - service: apache

# Debian only! Need a Redhat alternative.
a2enmod-enable:
  cmd:
    - run
    - cwd: /
    - name: a2enmod actions fastcgi alias

# Debian only! Need a Redhat alternative.
apache-restart:
  cmd:
    - run
    - cwd: /
    - name: service apache2 restart