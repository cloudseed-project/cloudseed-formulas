include:
  - wget

heroku.core:
  cmd.run:
    - name: wget -qO- https://toolbelt.heroku.com/install.sh | sh
    - unless: test -d /usr/local/heroku
    - require:
      - pkg: wget

