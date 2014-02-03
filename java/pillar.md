# Pillar Example

```yaml
# /srv/pillar/java.sls

# Attributes
# version - supports: 'v6', 'v7' // default is v6
# vendor  - supports: 'oracle', 'openjdk' // default is openjdk

# Example1

java:
  version: 'v7'
  vendor: 'oracle'
```
