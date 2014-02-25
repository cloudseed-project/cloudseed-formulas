{% from "ruby/map.jinja" import ruby with context %}

ruby.core:
  pkg:
    - installed
    - name: {{ ruby.package }}

ruby.dev:
  pkg:
    - installed
    - name: {{ ruby.dev }}
    - require:
      - pkg: ruby.core

ruby.gem:
  pkg:
    - installed
    - name: {{ ruby.gem }}
    - require:
      - pkg: ruby.core
      - pkg: ruby.dev

ruby.core.set.version:
  cmd.run:
    - name: ln -sf /usr/bin/ruby1.9.3 /usr/bin/ruby;

ruby.gem.set.version:
  cmd.run:
    - name: ln -sf /usr/bin/gem1.9.3 /usr/bin/gem;
