python.nginx.gunicorn:
    vhosts:
      foo.com:                      # Server name
                                    #
        server_alias: <optional>    # YAML Array of alias names, aka:
                                    # - www.example.com
                                    # - *.example.com
                                    # - foo.*
                                    #
        default_server: <optional>  # Defaults to False
                                    #
        port: <optional>            # Defaults to 80
                                    #
        access_log: <optional>      # Defaults to /var/log/nginx/foo.com.log
                                    #
        location: <optional>        # Defaults to /
                                    #
        proxy_pass: <optional>      # Defaults to http://127.0.0.1:8000
                                    #
        conf: <optional>            # Defaults to salt://python/nginx/files/gunicorn.vhost.conf
                                    #
        static_location: <optional> # Defaults to /static
                                    # This represents http://example.com/static
                                    # Where the browser should be requesting
                                    # static resources from. For Django, this should
                                    # be the same value as STATIC_URL in your
                                    # Django settings.
                                    #
        static_path: <optional>     # The absolute path on the server where the
                                    # static files are located.
                                    #
                                    # ** If this option is not defined static_location
                                    # no additional location nginx directive will
                                    # be rendered. **
                                    #
                                    #
        cors:                       # https://developer.mozilla.org/en-US/docs/HTTP/Access_control_CORS
                                    #
            origin: <optional>      # Defaults to $http_origin
                                    # Maps to: Access-Control-Allow-Origin
            methods: <optional>     #
                - GET               # Array of HTTP Methods you want to allow
                - OPTIONS           # GET, POST, PUT, DELETE, OPTIONS, etc...
                - POST              # Maps to: Access-Control-Allow-Methods
                                    #
            headers: <optional>     # Array of Headers to allow
                - Content-Type      # * must be quoted: '*'
                - Authorization     # Maps to: Access-Control-Allow-Headers
                - User-Agent        #
                - Keep-Alive        #
                                    #
            credentials: true       # Maps to: Access-Control-Allow-Credentials
                                    #
            max_age: 1728000        # Maps to: Access-Control-Max-Age
                                    # Defaults to 20 days
