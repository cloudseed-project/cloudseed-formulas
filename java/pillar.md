# Pillar Example

```yaml
# /srv/pillar/java.sls

# Attributes
# version - supports: '6', '7' // default is 6
# vendor  - supports: 'oracle', 'openjdk' // default is openjdk

# Example1

java:
  version: 7
  vendor: 'oracle'
```
