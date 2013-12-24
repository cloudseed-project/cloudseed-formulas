#!/bin/sh
export GIT_WORK_TREE={{ deploy_path }}
{{ hook_path }}/{{ hook_name }}.action
