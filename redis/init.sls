{% from "redis/map.jinja" import redis with context %}

redis:
  pkg:
    - installed
    - name: {{ redis.package }}
