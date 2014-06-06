#!pydsl


def postgresql_conf(saltenv, pg_utils):
    salt_get_managed =  __salt__['file.get_managed']
    salt_manage_file =  __salt__['file.manage_file']

    try:
        configuration_sources = __pillar__['postgresql']['configuration_sources']
    except:
        configuration_sources = {}

    postgres_version = pg_utils.pg_version()
    version = '.'.join(postgres_version.split('.')[0:2])

    data = pg_utils.defaults(version)

    target = data['postgresql_location']

    source = configuration_sources.get(
        'conf',
        'salt://postgresql/files/postgresql_{0}.conf'.format(version))

    sfn, source_sum, _ = salt_get_managed(
        name=target,
        template='jinja',
        source=source,
        source_hash=None,
        user='postgres',
        group='postgres',
        mode='700',
        saltenv=saltenv,
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
        mode='700',
        saltenv=saltenv,
        backup='',
        template='jinja',
        makedirs=True)


def states(pg_utils):
    state('postgresql.conf') \
      .cmd.call(postgresql_conf, __env__, pg_utils) \
      .require(pkg='postgresql.core',
               cmd='postgresql_conf_data_dir') \
      .watch_in(service='postgresql.service')
