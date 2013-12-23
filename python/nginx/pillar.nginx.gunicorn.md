python.nginx.gunicorn:
    vhosts:
      foo.com:
        port: <optional> # Defaults to 80
        access_log: <optional> #Defaults to /var/log/nginx/foo.com.log
        location: <optional> #Defaults to /
        proxy_pass: <optional> #Defaults to http://127.0.0.1:8000
        conf: <optional> # Defaults to salt://python/nginx/files/gunicorn.vhost.conf
