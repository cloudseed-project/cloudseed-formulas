firewall:
  install: True
  enabled: True
  strict: True
  services:
    ssh:
      block_nomatch: False
      ips_allow:
        - 192.168.0.0/24
        - 10.0.2.2/32

  whitelist:
    networks:
      ips_allow:
        - 10.0.0.0/8

  #Suppport nat
  # iptables -t nat -A POSTROUTING -o eth0 -s 192.168.18.0/24 -d 10.20.0.2 -j MASQUERADE
  # iptables -t nat -A POSTROUTING -o eth0 -s 192.168.18.0/24 -d 172.31.0.2 -j MASQUERADE
  nat:
    eth0:
      rules:
        '192.168.18.0/24':
          - 10.20.0.2
        '192.168.18.0/24':
          - 172.31.0.2
