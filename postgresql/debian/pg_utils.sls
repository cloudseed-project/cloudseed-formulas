#!pydsl


def defaults(version):
    try:
        config = __pillar__['postgresql']['basic_configuration']
    except:
        config = {}

    result = {
    'data_directory':  config.get('data_directory',
                                  '/var/lib/postgresql/%s/main' % version),

     'hba_file':       config.get('hba_file',
                                  '/etc/postgresql/%s/main/pg_hba.conf' % version),

     'ident_file':     config.get('ident_file',
                                  '/etc/postgresql/%s/main/pg_ident.conf' % version),

     'ctl_file':     config.get('ctl_file',
                                '/etc/postgresql/%s/main/pg_ctl.conf' % version),

     'listen_address': config.get('listen_address', '*'),
     'port':           config.get('port', '5432')
    }

    return result
