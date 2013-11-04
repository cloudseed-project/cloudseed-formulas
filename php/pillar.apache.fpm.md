php.apache.fpm:
    conf: salt://php/apache/files/fpm.conf
    pools:
      www:
        conf: <optional> # Defaults to salt://php/apache/files/fpm.pool.conf
        listen_address: <optional>  # Defaults to 127.0.0.1:9000 can also be path to socket fd, /tmp/foo.sock
        user: <optional> # Defaults to www-data
        group: <optional> # Defaults to www-data

    vhosts:
      foo.com:
        pool: <required> # Must match a pool name defined above, aka 'www'
        document_root: <required> # must be a valid path /srv/app/store
        conf: <optional> # Defaults to salt://php/apache/files/fpm.vhost.conf
        allow_override: <optional> # Defaults to 'None'
        directory_index: <optional> # Defaults to 'index.php'
        server_admin: <optional> # defaults to 'webmaster@localhost'
