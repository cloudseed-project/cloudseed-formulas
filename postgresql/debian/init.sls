#!pydsl


pg_utils, \
pg_data_dir, \
pg_postgresql_conf, \
pg_hba_conf, \
pg_ctl_conf, \
pg_ident_conf = include(
  'postgresql.debian.pg_utils',
  'postgresql.debian.pg_data_dir',
  'postgresql.debian.pg_postgresql_conf',
  'postgresql.debian.pg_hba_conf',
  'postgresql.debian.pg_ctl_conf',
  'postgresql.debian.pg_ident_conf'
)

pg_data_dir.states(pg_utils)
pg_postgresql_conf.states(pg_utils)
pg_hba_conf.states(pg_utils)
pg_ctl_conf.states(pg_utils)
pg_ident_conf.states(pg_utils)
