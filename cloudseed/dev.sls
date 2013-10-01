# cloudseed.install:
#   cmd.wait:
#     - name: python setup.py develop
#     - cwd: /root/cloudseed
#     - watch:
#       - git: cloudseed.git

# cloudseed.git:
#   git.latest:
#     - name: https://github.com/cloudseed-project/cloudseed2.git
#     - rev: master
#     - target: /root/cloudseed
