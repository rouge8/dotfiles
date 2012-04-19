#!/usr/bin/env python
# set PYTHONSTARTUP=~/.pythonrc.py to get this to work

import sys

try:
    from see import see
except ImportError:
    print >> sys.stderr, 'ImportError: see not found. :('

