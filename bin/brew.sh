#!/usr/bin/env bash

# configure
set -e
source bin/utils.sh || exit 1
#
# When you get confused about the yaml loops: https://github.com/jasperes/bash-yaml
#

CONFIG=$1
pecho "Reading config...\n"
# load yaml file using function in utils.sh
create_variables $CONFIG || exit 1

pecho "Install Xcode command line tools? [y/N]"
read -r response ; tput sgr0
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]] ; then
    # we will need this installed
    xcode-select --install || true
fi

# brew installed?
if [[ $(command -v brew) == "" ]]; then
    # install Homebrew
    echo "Installing brew:"
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
    echo "Brew already installed. Let's make sure your formulae are up to date:"
    brew update > /dev/null || exit 1
    brew upgrade > /dev/null || exit 1
fi

pecho "Installing taps...\n"
for i in ${tap[*]};do
    echo "Installing $i...\n"
    brew tap $i > /dev/null || exit 1
done

pecho "Installing packages...\n"
for i in ${packages__name[*]}; do
    pecho "Installing $i...\n"
    brew install $i > /dev/null || true
done

pecho "Install cask packages...\n"
for i in ${cask[*]};do
    pecho "Installing $i...\n"
    brew cask install $i > /dev/null || true
done

pecho "Would you like to install Mac App Store apps [y/N] "
read -r response ; tput sgr0
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]] ; then
    # Have to install mas so we can do the signin
    brew install mas > /dev/null || true

#    pecho "What is you iCloud account email address? "
#    read -r response ; tput sgr0
#    mas signin $response

    pecho "Installing Mac App Store apps...\n"
    for i in ${mas[*]}; do
        pecho "Installing $i...\n"
        mas install $i > /dev/null || true
    done
fi

pecho "Done!\n"
exit 0
