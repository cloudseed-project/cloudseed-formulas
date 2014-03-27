base:

  'master':
    - master

  'feature-centos':
    - madjango

  'roles:lamp':
    - match: grain
    - lamp

  'roles:git-deploy':
    - match: grain
    - git-deploy

  'roles:madjango':
    - match: grain
    - madjango

  'roles:mysql':
    - match: grain
    - mysql.server

  'roles:postgresql':
    - match: grain
    - postgresql

  'roles:node':
    - match: grain
    - node

  'roles:vim':
    - match: grain
    - vim

  'roles:redis':
    - match: grain
    - redis

  'roles:python':
    - match: grain
    - python

  'roles:vagrant':
    - match: grain
    - vagrant

feature-centos:

  'roles:madjango':
    - match: grain
    - madjango
