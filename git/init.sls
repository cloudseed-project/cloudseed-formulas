{% from "git/map.jinja" import git with context %}

git.core:
  pkg:
    - installed
    - name: {{ git.package }}
