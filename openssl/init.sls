{% from "openssl/map.jinja" import openssl with context %}

openssl.core:
  pkg:
    - installed
    - name: {{ openssl.package }}

openssl.dev:
  pkg:
    - installed
    - name: {{ openssl.dev }}

