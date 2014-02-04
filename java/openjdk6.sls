{% from "java/openjdk_map.jinja" import openjdk with context %}

java.core:
  pkg:
    - installed
    - name: {{ openjdk.package.v6 }}
