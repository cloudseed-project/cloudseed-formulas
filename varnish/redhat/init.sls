{% from "varnish/map.jinja" import varnish with context %}

varnish.lib:
    pkg:
    - installed
    - name: {{ varnish.lib }}
