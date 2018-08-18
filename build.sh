#!/bin/sh
set -e

git pull > /dev/null 2>&1

make build
make push

# exit codes:
# 0 - no action
# -1 - new build pushed
# rest - errors
