#!/usr/bin/env bash

# configure
set -e
source bin/utils.sh || exit 1

CONFIG=$1

pecho "Reading config...\n"
create_variables $CONFIG || exit 1

pecho "Updating npm...\n"
sudo npm update -g > /dev/null || exit 1
sudo npm update -g npm > /dev/null || exit 1

pecho "Installing packages...\n"
packages=${packages[*]}
for i in ${packages[*]}; do
    pecho "Installing $i...\n"
    sudo npm install -g --save $i > /dev/null || exit 1
done

exit 0
