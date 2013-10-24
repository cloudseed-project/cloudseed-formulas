#!pydsl

# Originally this file didn't exits. Instead the individual
# includes for were listed in the postgresql.init.sls file. There was
# a problem though. They all depend on postgresql.{{ os }}.pg_utils.
# Each module would import postgresql.{{ os }}.pg_utils. The problem
# was the only the first module to run, in this case
# postgresql.conf.pg_data_dir (the others require this to happen first).
# So pg_data_dir would successfully include() pg_utils, the subsequent
# modules to load however would return None for the
# include(postgresql.{{ os }}.pg_utils). This feels like a bug, but I can't
# say for sure as I don't know enough about the pydsl include system.
# Rather than fight with it, postgresql.{{ os }}.init was created.
#
# Here we import everything which we were previously doing in
# postgresql.init.sls. Since we know we at least get the 1st include to work
# for postgresql.{{ os }}.pg_utils, we just pass that as an argument to the
# other states that require it. This is a workaround the
# "ony imports once" issue.

pg_utils, \
pg_data_dir, \
pg_socket_dir, \
pg_postgresql_conf, \
pg_hba_conf, \
pg_ctl_conf, \
pg_ident_conf = include(
  'postgresql.debian.pg_utils',
  'postgresql.conf.pg_data_dir',
  'postgresql.conf.pg_socket_dir',
  'postgresql.conf.pg_postgresql_conf',
  'postgresql.conf.pg_hba_conf',
  'postgresql.conf.pg_ctl_conf',
  'postgresql.conf.pg_ident_conf'
)

pg_data_dir.states(pg_utils)
pg_socket_dir.states(pg_utils)
pg_postgresql_conf.states(pg_utils)
pg_hba_conf.states(pg_utils)
pg_ctl_conf.states(pg_utils)
pg_ident_conf.states(pg_utils)
