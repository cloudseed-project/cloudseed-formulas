include:
  - curl

heroku.core:
  cmd.run:
    - name: curl -L https://toolbelt.heroku.com/install.sh | sh
    - unless: test -d /usr/local/heroku
    - require:
      - pkg: curl.core

