#!/usr/bin/env bash

# configure
set -e
source bin/utils.sh || exit 1

CONFIG=$1

pecho "Updating pip...\n"
pip3 install --upgrade pip

pecho "Installing packages under Python3...\n"
pip3 install --upgrade -v --no-cache-dir -r $CONFIG > /dev/null || exit 1

exit 0
