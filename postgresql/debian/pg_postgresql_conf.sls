#!pydsl


def postgresql_debian_conf(pg_utils):
    salt_postgres_version = __salt__['postgres.version']
    salt_get_managed =  __salt__['file.get_managed']
    salt_manage_file =  __salt__['file.manage_file']
    salt_makedirs = __salt__['file.makedirs']

    try:
        pillar = __pillar__['postgresql']
    except:
        pillar = {}

    source = pillar.get('conf', 'salt://postgresql/files/postgresql.conf')
    postgres_version = salt_postgres_version()
    version = '.'.join(postgres_version.split('.')[0:2])

    data = pg_utils.defaults(version)

    target = '/etc/postgresql/%s/main/postgresql.conf' % version
    env = 'base'

    salt_makedirs(
        path=data['data_directory'],
        user='postgres',
        group='postgres',
        mode='755')

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
  state('postgresql.debian.conf') \
      .cmd.call(postgresql_debian_conf, pg_utils) \
      .require(pkg='postgresql.core', cmd='postgresql_debian_data_dir') \
      .watch_in(service='postgresql.service')
