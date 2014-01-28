# Cloudseed Formulas

Cloudseed Formulas replace Cloudseed States.


## Contributing

To avoid issues with caching and so that you don't need to keep pushing you tests to the repo while developing, follow this process ...

### Clone the repo and create a test instance of devbot

```
git clone git@github.com:cloudseed-project/cloudseed-formulas.git
mkdir test
cd test
devbot go
```

### Configure to use local changes rather than GitFS

Edit ```./Vagrantfile``` by adding:

```
config.vm.synced_folder "../cloudseed-formulas", "/salt-local"
```

Edit ```cloudseed/current/salt/master``` by updating the ```file_roots```

```
file_roots:
  base:
  - /salt-local
  - /srv/salt
```