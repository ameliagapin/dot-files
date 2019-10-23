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

pecho "Installing prereqs...\n"
pre=${pre_curl[*]}
for i in ${pre_curl[*]}; do
    pecho "Curling ${i}...\n"
    curl -sL ${i} | sudo -E bash - > /dev/null || exit 1
done

pecho "Adding repos...\n"
repos=${repos[*]}
for i in ${repos[*]};do
    sudo add-apt-repository -y $i > /dev/null || exit 1
done

pecho "Updating apt-get...\n"
sudo apt-get update > /dev/null

pecho "Installing packages...\n"
packages=${packages[*]}
for i in ${packages[*]}; do
    pecho "Installing $i...\n"
    sudo apt-get install -y $i > /dev/null || exit 1
done

pecho "Done!\n"
exit 0
