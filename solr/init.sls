{% set version = salt['pillar.get']('solr:version', '4.6.1') %}
{% set version_int = version.split('.')|join|int %}
{% set prefix = 'apache-' if version_int < 410 else '' %}
{% set filename = '%ssolr-%s'|format(prefix, version) %}
{% set basic_configuration     = salt['pillar.get']('solr:basic_configuration', {}) %}
{% set configuration_sources = salt['pillar.get']('solr:configuration_sources', {}) %}
{% set configuration_locations = salt['pillar.get']('solr:configuration_locations', {}) %}
{% set basic_authentication = salt['pillar.get']('solr:basic_authentication', None) %}
{% set install_location = configuration_locations.install_location|d('/srv/solr') %}

include:
  - curl
  - java.openjdk7

{% if grains['os_family'] == 'Debian' %}
solr.init:
    file.managed:
    - name: /etc/init/solr.conf
    - source: salt://solr/files/upstart.conf
    - mode: 644
    - template: jinja
    - defaults:
        install_location: {{ install_location }}
    - watch_in:
      - service: solr.service
{% elif grains['os_family'] == 'RedHat' %}
solr.init:
    file.managed:
    - name: /etc/init.d/solr
    - source: salt://solr/files/solr.sh
    - mode: 644
    - template: jinja
    - watch_in:
      - service: solr.service
      
{% endif %}

solr.service:
  service:
    - running
    - name: solr
    - enable: True
    - require:
      - file: solr.init
      - cmd: solr.download.install
    - watch:
      - file: solr.conf.jetty
      - file: solr.conf.webdefault

solr.download:
  cmd.run:
    - cwd: /tmp
    - name: curl -O https://archive.apache.org/dist/lucene/solr/{{ version }}/{{ filename }}.tgz
    - require:
        - pkg: curl.core
        - pkg: java.core
    - unless: test -e /srv/solr

solr.download.unpack:
  cmd.wait:
    - cwd: /tmp
    - name: tar xvzf {{ filename }}.tgz
    - watch:
        - cmd: solr.download

solr.download.install:
  cmd.wait:
    - cwd: /tmp
    - name: mv {{ filename }}/example {{ install_location }}
    - watch:
        - cmd: solr.download.unpack

solr.download.cleanup:
  cmd.wait:
    - cwd: /tmp
    - name: rm -rf {{ filename }} && rm -rf {{ filename }}.tgz
    - watch:
        - cmd: solr.download.install

solr.conf.jetty:
  file.managed:
    - name: {{ install_location }}/etc/jetty.xml
    - source: {{ configuration_sources.jetty|d('salt://solr/files/jetty.xml') }}
    - mode: 644
    - template: jinja
    - defaults:
        port: {{ basic_configuration.port|d('8983') }}
        listen_address: {{ basic_configuration.listen_address|d('0.0.0.0') }}
    - require:
      - cmd: solr.download.install

solr.conf.webdefault:
  file.managed:
    - name: {{ install_location }}/etc/webdefault.xml
    - source: {{ configuration_sources.jetty|d('salt://solr/files/webdefault.xml') }}
    - mode: 644
    - template: jinja
    - require:
      - cmd: solr.download.install

{% if basic_authentication %}
solr.conf.basic_auth.realm.properties:
  file.managed:
    - name: {{ install_location }}/etc/realm.properties
    - source: salt://solr/files/basic_auth.realm.properties
    - mode: 744
    - template: jinja
    - require:
      - cmd: solr.download.install
    - watch_in:
      - service: solr.service
{% endif %}
