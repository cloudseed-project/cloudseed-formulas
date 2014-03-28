# the node version needs to be externalized into a pillar

include:
  - build-tools
  - curl
  - openssl

node.core:
  cmd.run:
    - name: curl -L https://raw.github.com/isaacs/nave/master/nave.sh | sudo bash -s -- usemain 0.10.20
    - unless: test "v0.10.20" = "$(node -v)"
    - env:
        PREFIX: /usr/local/lib/node
        NAVE_JOBS: '1'
    - require:
      - pkg: build-tools.core
      - pkg: curl.core
      - pkg: openssl.dev


{% if grains['os_family'] == 'RedHat' %}

node.npm.symlink:
  cmd.run:
    - name: ln -sf /usr/local/bin/npm /usr/bin/;

node.node.symlink:
  cmd.run:
    - name: ln -sf /usr/local/bin/node /usr/bin/;

{% endif %}




 