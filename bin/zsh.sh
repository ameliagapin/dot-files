#!/usr/bin/env bash

# zsh should already be installed
source bin/utils.sh || exit 1

CUSTOM=$HOME/.oh-my-zsh/custom
OMZ=$HOME/.oh-my-zsh

# Install oh-my-zsh
pecho "Installing oh-my-zsh...\n"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Install spaceship
pecho "Installing spaceship...\n"
clone https://github.com/denysdovhan/spaceship-prompt.git "$CUSTOM/themes/spaceship-prompt" || true

pecho "Sym linking spaceship...\n"
sudo ln -sf "$CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$CUSTOM/themes/spaceship.zsh-theme" || exit 1

# pecho "Installing spaceship from npm...\n"
# npm install -g spaceship-prompt # || exit 1

pecho "Installing plugins...\n"
pecho "Installing zsh-autosuggetions...\n"
clone https://github.com/zsh-users/zsh-autosuggestions ${OMZ}/plugins/zsh-autosuggestions || true
pecho "Installing zsh-syntax-highlighting...\n"
clone https://github.com/zsh-users/zsh-syntax-highlighting ${OMZ}/plugins/zsh-syntax-highlighting || true
pecho "Installing navi...\n"
clone https://github.com/denisidoro/navi ${OMZ}/plugins/navi || true

exit 0
