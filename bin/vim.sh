#!/bin/sh

# configure
set -e
source bin/utils.sh || exit 1

pecho "Would you like to clean and install vim plugins [y/N] "
read -r response ; tput sgr0
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]] ; then
    pecho "Cleaning/Installing/Updating Vim plugins:\n"

    vim +PlugClean +PlugUpdate +PlugInstall +qall

    pecho "Installing YouCompleteMe...\n"
    cd ~/.vim/plugged/YouCompleteMe
    sudo $(which python3) ./install.py --all

    pecho "Creating vim undo directory...\n"
    mkdir -p ~/.vim/undo

    pecho "Installing Go binaries...\n"
    vim +GoInstallBinaries +qall

    cd "${BASEDIR}"
fi
