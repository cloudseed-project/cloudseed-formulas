#!pydsl


def postgresql_conf_data_dir(env, pg_utils):
    salt_postgres_version = __salt__['postgres.version']
    salt_makedirs = __salt__['file.makedirs_perms']
    salt_directory_exists = __salt__['file.directory_exists']
    salt_cmd_run =  __salt__['cmd.run']

    try:
        pillar = __pillar__['postgresql']
    except:
        pillar = {}

    postgres_version = salt_postgres_version()
    if not postgres_version:
        postgres_version = salt_cmd_run(
            "psql --version | sed -E s/[^0-9\.]*//g | tr -d '\n'",
            shell='/bin/bash')

    version = '.'.join(postgres_version.split('.')[0:2])

    data = pg_utils.defaults(version)

    ret = {
    'result': True,
    'comment': '%s exists' % data['data_directory']
    }

    if not salt_directory_exists(data['data_directory']):
        salt_makedirs(
            name=data['data_directory'],
            user='postgres',
            group='postgres',
            mode='755')

        ret['changes'] = {'retval': True}

    return ret


def states(pg_utils):
  state('postgresql.conf.data_dir') \
      .cmd.call(postgresql_conf_data_dir, __env__, pg_utils) \
      .require(pkg='postgresql.core') \
      .watch_in(service='postgresql.service')

