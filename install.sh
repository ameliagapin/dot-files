#!/usr/bin/env bash

# Automated installer for ameliagapin/dotfiles using dotbot (anishathalye/dotbot)

source bin/utils.sh

###############################################################################
# dotbot install
###############################################################################

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

DOTBOT_DIR="dotbot"
DOTBOT_BIN="bin/dotbot"

pecho "Would you like to install dotbot [y/N] "
read -r response ; tput sgr0
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]] ; then
    echo "Installing dotbot:"
    git submodule add -f https://github.com/anishathalye/dotbot.git
else
    pecho "Would you like to update dotbot [y/N] "
    read -r response ; tput sgr0
    if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]] ; then
        echo "Updating dotbot:"
        git submodule update --init --recursive "${DOTBOT_DIR}"
    fi
fi

###############################################################################
# Link dotfiles
###############################################################################

CONFIG="configs/dotfiles.yaml"

pecho "Would you like to link dotfiles [y/N] "
read -r response ; tput sgr0
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]] ; then
    echo "Linking dotfiles:"

    "${BASEDIR}/${DOTBOT_DIR}/${DOTBOT_BIN}" -d "${BASEDIR}" -c "${CONFIG}" "${@}"
fi

###############################################################################
# Install apt-get packages
###############################################################################

APT_GET_CMD=$(which apt-get 2> /dev/null)

if [[ ! -z $APT_GET_CMD ]] ; then
    CONFIG="configs/aptget.yaml"

    pecho "Would you like to install apt-get packages [y/N] "
    read -r response ; tput sgr0
    if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]] ; then
        echo "Installing apt-get packages:"

        bin/aptget.sh "${CONFIG}" || exit 1
        # # Ack-grep needs to be renamed to ack because it's in the apt-get repo as ack-grep
        # echo "Renaming ack-grep to ack..."
        # sudo dpkg-divert --quiet --local --divert /usr/bin/ack --rename --add /usr/bin/ack-grep || echo "FAILED"
    fi
fi

###############################################################################
# Install yum packages
###############################################################################

YUM_CMD=$(which yum) 2> /dev/null

if [[ ! -z $YUM_CMD ]]; then
    CONFIG="configs/yum.yaml"

    pecho "Would you like to install yum packages [y/N] "
    read -r response ; tput sgr0
    if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]] ; then
        echo "Installing yum packages:"

        bin/yum.sh "${CONFIG}" || exit 1
    fi
fi

###############################################################################
# Install brew + formulae (macOS only)
###############################################################################

if [[ "$OSTYPE" =~ ^darwin ]] ; then
    CONFIG="configs/brew.yaml"

    ## install homebrew + formulae?
    pecho "Would you like to install Homebrew (http://brew.sh/) + my formulae? [y/N] "
    read -r response ; tput sgr0
    if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]] ; then
          bin/brew.sh "${CONFIG}" ${do_mas} || exit 1
    fi
fi

###############################################################################
# Set macOS System Prefs
###############################################################################

if [[ "$OSTYPE" =~ ^darwin ]] ; then
    pecho "Would you like to set your computer name (as done via System Preferences >> Sharing)?  (y/N) "
    read -r response ; tput sgr0
    if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
      pecho "What would you like it to be?"
      read COMPUTER_NAME
      sudo scutil --set ComputerName $COMPUTER_NAME
      sudo scutil --set HostName $COMPUTER_NAME
      sudo scutil --set LocalHostName $COMPUTER_NAME
      sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string $COMPUTER_NAME
    fi

    pecho "Would you like to set macOS prefs? [y/N] "
    read -r response ; tput sgr0
    if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]] ; then
        source configs/macos
    fi

    pecho "Would you like to set iTerm2 prefs? [y/N] "
    read -r response ; tput sgr0
    if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]] ; then
        # Specify the preferences directory
        defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "~/.iterm"
        # Tell iTerm2 to use the custom preferences in the directory
        defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true
    fi
fi

###############################################################################
# Install npm packages
###############################################################################

CONFIG="configs/npm.yaml"

pecho "Would you like to install npm packages [y/N] "
read -r response ; tput sgr0
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]] ; then
    echo "Installing npm packages:"

    bin/npm.sh "${CONFIG}" || exit 1
fi

###############################################################################
# Install pip packages
###############################################################################

CONFIG="configs/pip.txt"

pecho "Would you like to install pip packages [y/N] "
read -r response ; tput sgr0
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]] ; then
    echo "Installing pip packages:"

    bin/pip.sh "${CONFIG}" || exit 1
fi

###############################################################################
# Install vagrant plugins
###############################################################################

pecho "Would you like to install vagrant plugins [y/N] "
read -r response ; tput sgr0
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]] ; then
    echo "Installing vagrant plugins:"

    vagrant plugin install vagrant-s3auth
    vagrant plugin install vagrant-aws
fi

###############################################################################
# Update Vim plugins
###############################################################################

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

###############################################################################
# Powerline fonts
###############################################################################

pecho "Would you like to install powerline fonts (for vim and zsh)? [y/N] "
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]] ; then
    cd ~/.vim/plugged/powerline-fonts
    if [ $? -eq 0 ]; then
        ./install.sh
    fi

    git clone https://github.com/powerline/fonts.git --depth=1
    if [ $? -eq 0 ]; then
        cd fonts
        if [ $? -eq 0 ]; then
           ./install.sh
            cd ..
            rm -rf fonts
        fi
    fi
fi

cd "${BASEDIR}"


###############################################################################
# Configure ZSH
###############################################################################

pecho "Would you like to configure zsh [y/N] "

read -r response ; tput sgr0
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]] ; then
    echo "Configuring zsh:"
    sudo bin/zsh.sh || exit 1

    # make default
    pecho "Setting zsh as default...\n"
    chsh -s $(which zsh) || exit 1
fi

###############################################################################
# Finish
###############################################################################

pecho "Done!"
