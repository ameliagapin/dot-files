#!/usr/bin/env bash

function pecho() {
    local PRINT_COLOR=6
    if [[ ! -z "$2" ]] ; then
        PRINT_COLOR=$2
    fi

    echo -ne "$(tput setaf "${PRINT_COLOR}")$1$(tput sgr0)"
}

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
