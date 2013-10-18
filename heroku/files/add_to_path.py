#! /usr/bin/python
from __future__ import print_function
import os
import sys
import re
import fileinput

PATTERN = re.compile(r'(?P<path>^[^#]*?PATH=([^#]+))(?P<suffix>(?:#.+)?)')
HEROKU_INSTALL_PATH = '/usr/local/heroku/bin'


def has_path(filename):
    with open(filename, 'r') as f:
        for line in f:
            if path_components(line):
                return filename


def path_components(line):
    match = PATTERN.search(line)

    if match:
        if HEROKU_INSTALL_PATH in match.group('path'):
            return
        return match.group('path').rstrip(), match.group('suffix')


def get_target(*args):
    for each in args:
        if os.path.isfile(each) and has_path(each):
            return each


def main(path):

    paths = ['%s/%s' % (path, x) for x in (
        '.profile',
        '.bashrc',
        '.bash_profile')]

    target = get_target(*paths)

    if not target:
        return

    f = fileinput.input(target, inplace=True)
    #f = open(target, 'r')
    for line in f:

        parts = path_components(line)

        if not parts:
            print(line.rstrip())
            continue

        prefix, suffix = parts

        if prefix.endswith('"'):
            sentinel = '"'
            prefix = prefix[:-1]
        else:
            sentinel = ''

        print('%s:%s%s %s' % (prefix, HEROKU_INSTALL_PATH, sentinel, suffix))

    f.close()


if __name__ == '__main__':
    path = sys.argv[1]

    if path.endswith('/'):
        path = path[:-1]

    main(path)
