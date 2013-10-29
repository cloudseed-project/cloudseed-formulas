#!pydsl


def pg_version():
    result = None
    try:
        version = __salt__['postgres.version']
    except KeyError:
        version = cli_postgres_version

    result = version()

    return result


def cli_postgres_version():
    salt_cmd_run =  __salt__['cmd.run']
    postgres_version = salt_cmd_run(
            "psql --version | sed -E s/[^0-9\.]*//g | tr -d '\n'",
            shell='/bin/bash')

    return postgres_version


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

    'listen_address':        basics.get('listen_address', '*'),
    'port':                  basics.get('port', '5432'),
    'version':               version,
    }

    return result
