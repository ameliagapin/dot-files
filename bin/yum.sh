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
for i in ${pre_curl[*]}; do
    pecho "Curling ${i}...\n"
    curl -sL ${i} | sudo -E bash - > /dev/null || exit 1
done

pecho "Adding repos...\n"
for i in ${repos[*]}; do
    sudo yum-config-manager --add-repo -y $i > /dev/null || exit 1
done

pecho "Enabling all repos...\n"
# yum-config-manager --enable \*

pecho "Updating yum...\n"
sudo yum check-update > /dev/null || true
sudo yum update > /dev/null || true

pecho "Installing packages...\n"
for i in ${packages[*]}; do
    pecho "Installing $i...\n"
    sudo yum -y install $i > /dev/null || true
done

pecho "Installing fzf...\n"
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install || exit 1

pecho "Done!\n"
exit 0
