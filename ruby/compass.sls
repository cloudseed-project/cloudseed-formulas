include:
  - ruby

ruby.listen:
  gem:
    - installed
    - name: listen
    - require:
      - pkg: ruby.gem

ruby.rbinotify:
  gem:
    - installed
    - name: rb-inotify
    - require:
      - pkg: ruby.gem

ruby.compass:
  gem:
    - installed
    - name: compass
    - require:
      - pkg: ruby.gem
