#!pydsl


def defaults(version):
    try:
        basics = __pillar__['postgresql']['basic_configuration']
    except:
        basics = {}

    try:
        locations = __pillar__['postgresql']['configuration_locations']
    except:
        locations = {}

    pgdata = locations.get('pgdata', '/var/lib/pgsql/data')

    result = {
    'pgdata':                pgdata,

    'data_directory':        locations.get('data_directory', pgdata),

    'unix_socket_directory': locations.get('unix_socket_directory',
                                           '/var/run/postgresql'),

    'sysconfig_location':    locations.get('sysconfig_location',
                                         '/etc/sysconfig/pgsql/postgresql'),

    'postgresql_location':   locations.get('postgresql_location',
                                         '%s/postgresql.conf' % pgdata),

    'hba_location':          locations.get('hba_location',
                                         '%s/pg_hba.conf' % pgdata),

    'ident_location':        locations.get('ident_location',
                                         '%s/pg_ident.conf' % pgdata),

    'ctl_location':          locations.get('ctl_location',
                                         '%s/pg_ctl.conf' % pgdata),

    'listen_address':      basics.get('listen_address', '*'),
    'port':                basics.get('port', '5432'),
    'version':             version,
    }

    return result
