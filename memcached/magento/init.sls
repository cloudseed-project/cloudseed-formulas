#!pydsl

from xml.dom import minidom
import os.path
import sys
#import time
import imp
import xml.etree.ElementTree as etree

include('vagrant.store')

mage_local = os.path.abspath('store/app/etc/local.xml')

def xmlmerge():
    #time.sleep(10) 
    salt_get_managed =  __salt__['file.get_managed']
    salt_manage_file =  __salt__['file.manage_file']

    if os.path.isfile(mage_local) == True:

        local = etree \
            .parse(mage_local) \
            .getroot()

        memcache = etree \
            .parse(mage_local+'.memcache') \
            .getroot() \
            .find('cache')

        if local.find('memcached') is None:
            # memcache hasn't been added so we are adding it now.
            local.append(memcache)
            raw = etree.tostring(local, 'utf-8')
            output = minidom \
                .parseString(raw) \
                .toprettyxml(indent=" ", newl="")

            sfn, source_sum, _ = salt_get_managed(
                name=mage_local,
                template=None,
                source=None,
                source_hash=None,
                user=None,
                group=None,
                mode=None,
                env=None,
                context=None,
                defaults=None)

            return salt_manage_file(
                name=mage_local,
                sfn=sfn,
                ret=None,
                source={},
                source_sum={},
                user={},
                group={},
                mode={},
                env={},
                backup='',
                template='',
                contents=output)
        else:
            return "memcached reference not found in local.xml"
    else:
        return "local.xml does not exist yet"

extend(
    state('memcached.magento.config') \
        .cmd.call(xmlmerge) \
        .require(cmd='app.store.prepare') \
        .require(cmd='app.store.initialize.receipt') 
)