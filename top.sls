base:

  'master':
    - master

  'roles:lamp':
    - match: grain
    - apache
    - apache.vhost.standard
    - mysql.server
    - php

  'roles:git-deploy':
    - match: grain
    - git-deploy

  'roles:mysql':
    - match: grain
    - mysql.server

  'roles:postgresql':
    - match: grain
    - postgresql