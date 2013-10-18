#! /usr/bin/python
from __future__ import print_function
import os
import sys
import re

PATTERN = re.compile(r'(?P<path>^[^#]*?PATH=([^#]+))(?P<suffix>(?:#.+)?)')
HEROKU_INSTALL_PATH = '/usr/local/heroku/bin'

ADD_TO_PATH = '''
# set PATH so it includes heroku bin if it exists
if [ -d "%(path)s" ] ; then
    PATH="$PATH:%(path)s"
fi
''' % {'path': HEROKU_INSTALL_PATH}


def has_path(filename):
    with open(filename, 'r') as f:
        if ADD_TO_PATH in f.read():
            return True
        return False


def path_components(line):
    match = PATTERN.search(line)

    if match:
        if HEROKU_INSTALL_PATH in match.group('path'):
            return
        return match.group('path').rstrip(), match.group('suffix')


def get_target(*args):
    valid_files = []

    for each in args:
        if os.path.isfile(each):
            if has_path(each):
                return None
            valid_files.append(each)

    return valid_files[0]


def main(path):
    paths = ['%s/%s' % (path, x) for x in (
        '.profile',
        '.bashrc',
        '.bash_profile')]

    target = get_target(*paths)

    if not target:
        return

    with open(target, 'a') as f:
        f.write(ADD_TO_PATH)

if __name__ == '__main__':
    path = sys.argv[1]

    if path.endswith('/'):
        path = path[:-1]

    main(path)
