#!/usr/bin/env bash

# configure
set -e
source bin/utils.sh || exit 1

CONFIG=$1

pecho "Updating pip...\n"
sudo -H pip3 install --upgrade pip
sudo -H pip2 install --upgrade pip

pecho "Installing packages under Python3...\n"
sudo -H pip3 install -v --no-cache-dir -r $CONFIG > /dev/null || exit 1

pecho "Installing packages under Python2...\n"
sudo -H pip install -v --no-cache-dir -r $CONFIG > /dev/null || exit 1

exit 0
