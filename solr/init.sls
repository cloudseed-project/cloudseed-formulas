{% set version = salt['pillar.get']('solr:version', '4.6.1') %}
{% set version_int = version.split('.')|join|int %}
{% set prefix = 'apache-' if version_int <= 410 else '' %}
{% set filename = '%ssolr-%s'|format(prefix, version) %}

include:
  - curl
  - java.openjdk7

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
    - name: mv {{ filename }}/example /srv/solr
    - watch:
        - cmd: solr.download.unpack

solr.download.cleanup:
  cmd.wait:
    - cwd: /tmp
    - name: rm -rf {{ filename }} && rm -rf {{ filename }}.tgz
    - watch:
        - cmd: solr.download.install
