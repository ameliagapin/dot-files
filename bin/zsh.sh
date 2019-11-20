#!/usr/bin/env bash

# zsh should already be installed
source bin/utils.sh || exit 1

CUSTOM=$HOME/.oh-my-zsh/custom
OMZ=$HOME/.oh-my-zsh

# On CentOS we need to make sure we have the newest version of zsh
YUM_CMD=$(which yum) 2> /dev/null
if [[ ! -z $YUM_CMD ]]; then
    pecho "Updating your version of ZSH..."
    sudo yum -y update --skip-broken || exit 1
    sudo yum -y install zsh || exit 1
fi

# If omz is already present, we can delete it and do a clean install of it
# Otherwise, let's just leave it be
if [[ -d ~/.oh-my-zsh ]]; then
    pecho "Would you like remove oh-my-zsh and start fresh [y/N] "
    read -r response ; tput sgr0
    if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]] ; then
        rm -rf ~/.oh-my-zsh
    fi

    # Install oh-my-zsh
    pecho "Installing oh-my-zsh...\n"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

    # The install overwrites our ~/.zshrc file so we gotta put it back
    cp ~/.zshrc.pre-oh-my-zsh ~/.zshrc
fi

# Install spaceship
pecho "Installing spaceship...\n"
clone https://github.com/denysdovhan/spaceship-prompt.git "$CUSTOM/themes/spaceship-prompt"

pecho "Sym linking spaceship...\n"
sudo ln -sf "$CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$CUSTOM/themes/spaceship.zsh-theme" || exit 1

# pecho "Installing spaceship from npm...\n"
# npm install -g spaceship-prompt # || exit 1

pecho "Installing plugins...\n"

pecho "Installing zsh-autosuggetions...\n"
clone https://github.com/zsh-users/zsh-autosuggestions ${OMZ}/plugins/zsh-autosuggestions

pecho "Installing zsh-syntax-highlighting...\n"
clone https://github.com/zsh-users/zsh-syntax-highlighting ${OMZ}/plugins/zsh-syntax-highlighting

pecho "Installing navi...\n"
clone https://github.com/denisidoro/navi ${OMZ}/plugins/navi

exit 0
