```yaml
php.nginx.fpm:
    pools:
      www:
        conf: <optional> # Defaults to salt://php/apache/files/fpm.pool.conf
        listen_address: <optional>  # Defaults to 127.0.0.1:9000 can also be path to socket fd, /tmp/foo.sock
        user: <optional> # Defaults to www-data
        group: <optional> # Defaults to www-data
        ini:
          <key>:<value>  # PHP ini overrides for this pool.
                         # The bottom of file php/apache/files/fpm.pool.conf
                         # for examples
                         # eg:
                         # php_flag[display_errors]: on
                         # php_admin_value[memory_limit]: 32M

    vhosts:
      foo.com:                       # Server name (aka name_key)
                                     #
        pool: <required>             # Must match a pool name defined above, aka 'www'
        server_alias: <optional>     # YAML Array of alias names, aka:
        app_name:     <optional>     # Defaults to name_key(aka foo.com).split('.')[0]
                                     #
                                     # - www.example.com
                                     # - *.example.com
                                     # - foo.*
                                     #
        default_server: <optional>   # Defaults to False
                                     #
        port: <optional>             # Defaults to 80
                                     #
        access_log: <optional>       # Defaults to /var/log/nginx/foo.com.log
                                     #
        location: <optional>         # Defaults to /
                                     #
        conf: <optional>             # Defaults to salt://python/nginx/files/gunicorn.vhost.conf
                                     #
        static_location: <optional>  # Defaults to /static
                                     # This represents http://example.com/static
                                     # Where the browser should be requesting
                                     # static resources from. For Django, this should
                                     # be the same value as STATIC_URL in your
                                     # Django settings.
                                     #
        static_path: <optional>      # The absolute path on the server where the
                                     # static files are located.
                                     #
                                     # ** If this option is not defined static_location
                                     # no additional location nginx directive will
                                     # be rendered. **
                                     #
                                     #
        cors:                        # https://developer.mozilla.org/en-US/docs/HTTP/Access_control_CORS
                                     #
            origin: <optional>       # Defaults to $http_origin
                                     # Maps to: Access-Control-Allow-Origin
            methods: <optional>      #
                - GET                # Array of HTTP Methods you want to allow
                - OPTIONS            # GET, POST, PUT, DELETE, OPTIONS, etc...
                - POST               # Maps to: Access-Control-Allow-Methods
                                     #
            headers: <optional>      # Array of Headers to allow
                - Content-Type       # * must be quoted: '*'
                - Authorization      # Maps to: Access-Control-Allow-Headers
                - User-Agent         #
                - Keep-Alive         #
                                     #
            credentials: true        # Maps to: Access-Control-Allow-Credentials
                                     #
            max_age: 1728000         # Maps to: Access-Control-Max-Age
                                     # Defaults to 20 days
    nginx:
        sendfile: <optional>         # Defaults to on
        worker_processes: <optional> # Defaults to 1
```
