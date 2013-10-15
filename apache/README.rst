apache
===

Install and configure the Apache service.

.. note::

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/topics/conventions/formulas.html>`_.

Available states
----------------

``foo``
    Install the ``foo`` package and enable the service.
``foo.bar``
    Install the ``bar`` package.

Supports
----------------
* Ubuntu
* Redhat (untested)



## Notes

PHP can be included using a pillar or top files.

Examples:

```
# State: top.sls
base:
  '*':
    - apache
    - apache.modules.php
```

```
# Pillar: apache.sls
apache:
  modules:
    php
```