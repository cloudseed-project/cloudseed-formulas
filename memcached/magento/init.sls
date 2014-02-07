#!pydsl

from xml.etree import ElementTree
from xml.dom import minidom

local = ElementTree.parse('store/app/etc/local.xml').getroot()
memcache = ElementTree.parse('store/app/etc/local.xml.memcache').getroot().find('cache')

if local.find('memcached') is None:
    # memcache hasn't been added so we are adding it now.
    local.append(memcache)
    raw = ElementTree.tostring(local, 'utf-8')
    output = minidom \
        .parseString(raw) \
        .toprettyxml(indent="  ", newl="")

    memcached_magento = state('memcached.magento.config')
    memcached_magento.file('managed',
            name='/srv/app/store/app/etc/foooobarr.xml',
            contents=output)