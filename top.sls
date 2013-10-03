base:

  'master':
    - master

  'roles:lamp':
    - match: grain
    - apache

  'roles:git-deploy':
    - match: grain
    - git-deploy

  'roles:mysql':
    - match: grain
    - mysql.server

  'roles:postgresql':
    - match: grain
    - postgresql