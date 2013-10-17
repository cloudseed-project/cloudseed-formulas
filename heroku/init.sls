include:
  - wget

heroku.standalone:
  cmd.run:
    - name: wget -qO- https://toolbelt.heroku.com/install.sh | sh
    - require:
      - pkg: wget


# class app::heroku {
#     exec{'install-heroku':
#         command => "wget -qO- toolbelt.heroku.com/install-ubuntu.sh | sh",
#         creates  => "/usr/bin/heroku",
#         user    => vagrant,
#     }
# }

