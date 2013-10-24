#!pydsl


def postgresql_debian_data_dir(pg_utils):
    salt_postgres_version = __salt__['postgres.version']
    salt_makedirs = __salt__['file.makedirs']
    salt_directory_exists = __salt__['file.directory_exists']

    try:
        pillar = __pillar__['postgresql']
    except:
        pillar = {}

    postgres_version = salt_postgres_version()
    version = '.'.join(postgres_version.split('.')[0:2])

    data = pg_utils.defaults(version)

    ret = {
    'result': True,
    'comment': '%s exists' % data['data_directory']
    }

    if not salt_directory_exists(data['data_directory']):
        salt_makedirs(
            path=data['data_directory'],
            user='postgres',
            group='postgres',
            mode='755')

        ret['changes'] = {'retval': True}

    return ret


def states(pg_utils):
  state('postgresql.debian.data_dir') \
      .cmd.call(postgresql_debian_data_dir, pg_utils) \
      .require(pkg='postgresql.core', cmd='postgresql_debian_data_dir') \
      .watch_in(service='postgresql.service')

