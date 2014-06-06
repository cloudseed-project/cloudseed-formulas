#!pydsl


def postgresql_conf_data_dir(env, pg_utils):
    salt_makedirs = __salt__['file.makedirs_perms']
    salt_directory_exists = __salt__['file.directory_exists']

    try:
        pillar = __pillar__['postgresql']
    except:
        pillar = {}

    postgres_version = pg_utils.pg_version()
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
            mode='700')

        ret['changes'] = {'retval': True}

    return ret


def states(pg_utils):
    state('postgresql.conf.data_dir') \
      .cmd.call(postgresql_conf_data_dir, __env__, pg_utils) \
      .require(
        pkg='postgresql.core') \
      .watch_in(service='postgresql.service')

