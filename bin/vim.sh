#!/bin/sh

# configure
set -e
source bin/utils.sh || exit 1

# CentOS 7 may need a vim upgrade
YUM_CMD=$(which yum) 2> /dev/null
if [[ ! -z $YUM_CMD ]]; then
    pecho "Do you need to update vim? You currently have version $(vim --version | head -1 | cut -d ' ' -f 5) [y/N] "
    read -r response ; tput sgr0
    if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]] ; then
        rpm -Uvh http://mirror.ghettoforge.org/distributions/gf/gf-release-latest.gf.el7.noarch.rpm
        rpm --import http://mirror.ghettoforge.org/distributions/gf/RPM-GPG-KEY-gf.el7
        yum -y remove vim-minimal vim-common vim-enhanced
        yum -y --enablerepo=gf-plus install vim-enhanced
    fi
fi

pecho "Would you like to clean and install vim plugins [y/N] "
read -r response ; tput sgr0
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]] ; then
    pecho "Cleaning/Installing/Updating Vim plugins:\n"

    vim +PlugClean +PlugUpdate +PlugInstall +qall

    pecho "Installing YouCompleteMe...\n"
    cd ~/.vim/plugged/YouCompleteMe
    $(which python3) ./install.py --all

    pecho "Creating vim undo directory...\n"
    mkdir -p ~/.vim/undo

    pecho "Installing Go binaries...\n"
    vim +GoInstallBinaries +qall

    cd "${BASEDIR}"
fi
