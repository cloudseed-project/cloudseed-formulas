include:
  - ubuntu.ppa

oracle.ubuntu.ppa:
  pkgrepo.managed:
    - ppa: webupd8team/java
    - require:
      - pkg: ubuntu.ppa.support

oracle.ubuntu.license.1:
  cmd.run:
    - name: echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections

oracle.ubuntu.license.2:
  cmd.run:
    - name: echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
