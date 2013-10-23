#!pydsl


def postgresql_debian_conf():
    postgres_version = __salt__['postgres.version']()
    version = '.'.join(postgres_version.split('.')[0:2])
    source = 'salt://postgresql/files/postgresql.conf'
    env = 'base'



    sfn, source_sum, _ = __salt__['file.get_managed'](
        name='/etc/postgresql/%s/main/postgresql.conf' % version,
        template=None,
        source=source,
        source_hash=None,
        user='postgres',
        group='postgres',
        mode='644',
        env=env,
        context=None,
        defaults=None)

    return __salt__['file.manage_file'](
        name='/etc/postgresql/%s/main/postgresql.conf' % version,
        sfn=sfn,
        ret=None,
        source=source,
        source_sum=source_sum,
        user='postgres',
        group='postgres',
        mode='644',
        env=env,
        backup='')


state('postgresql.debian.conf') \
    .cmd.call(postgresql_debian_conf) \
    .require(pkg='postgresql.core') \
    .watch_in(service='postgresql.service')
