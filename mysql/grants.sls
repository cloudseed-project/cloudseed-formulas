#!pydsl
from salt.modules import mysql
from salt.states import mysql_grants


mysql_grants.__salt__ = __salt__
mysql.__salt__ = __salt__


# configuration
grants = __salt__['pillar.get']('mysql:grants', [])
port = __salt__['pillar.get']('mysql:basic_configuration:port', 3306)
username = 'root'
password = __salt__['pillar.get']('mysql:basic_configuration:root_password', '')

connection_args = {
    'mysql.host': 'localhost',
    'mysql.port': port,
    'mysql.user': username,
    'mysql.pass': password,
    'mysql.db': 'mysql'
}

for obj in grants:
    name = 'mysql.grant.%s.%s' % (obj['user'], obj['host'])

    state(name) \
        .mysql_grants.present(
            grant=obj.get('grant'),
            database=obj.get('database'),
            user=obj.get('user'),
            host=obj.get('host', 'localhost'),
            grant_option=False,
            escape=True,
            revoke_first=False,
            **connection_args) \
        .require(
            pkg='mysql.salt.support',
            cmd=['mysql.root.password',
                 'mysql.user.%s.%s' % (obj['user'], obj.get('host', 'localhost')),
                 'mysql.db.%s' % obj['database'].split('.')[0]
                 ]
            )
