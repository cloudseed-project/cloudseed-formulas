include:
  - apache

php5:
  pkg:
    - installed

php5-curl:
  pkg:
    - installed
    - watch_in:
      - service: apache

php5-gd:
  pkg:
    - installed
    - watch_in:
      - service: apache

libapache2-mod-php5:
  pkg:
    - installed
    - require:
      - pkg: apache

    - watch_in:
      - service: apache

/etc/apache2/sites-available/default:
  file.managed:
    - source: salt://lamp-basic/files/host.conf
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - watch_in:
      - service: apache

a2enmod rewrite:
  cmd.run:
    - onlyif: test -e /etc/apache2/mods-enabled/rewrite.load
    - watch_in:
      - service: apache
