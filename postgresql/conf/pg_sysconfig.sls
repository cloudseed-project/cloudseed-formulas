#!pydsl


def postgresql_sysconfig_conf(env, pg_utils):
    salt_get_managed =  __salt__['file.get_managed']
    salt_manage_file =  __salt__['file.manage_file']

    try:
        configuration_sources = __pillar__['postgresql']['configuration_sources']
    except:
        configuration_sources = {}

    postgres_version = pg_utils.version()
    version = '.'.join(postgres_version.split('.')[0:2])

    data = pg_utils.defaults(version)

    target = data['sysconfig_location']

    source = configuration_sources.get(
        'sysconfig',
        'salt://postgresql/files/postgresql-sysconfig.conf')

    sfn, source_sum, _ = salt_get_managed(
        name=target,
        template='jinja',
        source=source,
        source_hash=None,
        user='postgres',
        group='postgres',
        mode='644',
        env=env,
        context=None,
        defaults=data)

    return salt_manage_file(
        name=target,
        sfn=sfn,
        ret=None,
        source=source,
        source_sum=source_sum,
        user='postgres',
        group='postgres',
        mode='644',
        env=env,
        backup='',
        template='jinja')


def states(pg_utils):
    state('postgresql.sysconfig.conf') \
      .cmd.call(postgresql_sysconfig_conf, __env__, pg_utils) \
      .require(pkg='postgresql.core',
               service='postgresql.service',
               cmd='postgresql_conf_data_dir') \
      .watch_in(service='postgresql.service')
