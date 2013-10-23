#!pydsl


def postgresql_debian_hba():
    postgres_version = __salt__['postgres.version']()
    version = '.'.join(postgres_version.split('.')[0:2])
    source = 'salt://postgresql/files/pg_hba.conf'
    env = 'base'



    sfn, source_sum, _ = __salt__['file.get_managed'](
        name='/etc/postgresql/%s/main/pg_hba.conf' % version,
        template='jinja',
        source=source,
        source_hash=None,
        user='postgres',
        group='postgres',
        mode='644',
        env=env,
        context=None,
        defaults=None)

    return __salt__['file.manage_file'](
        name='/etc/postgresql/%s/main/pg_hba.conf' % version,
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


state('postgresql.debian.hba') \
    .cmd.call(postgresql_debian_hba) \
    .require(pkg='postgresql.core') \
    .watch_in(service='postgresql.service')
