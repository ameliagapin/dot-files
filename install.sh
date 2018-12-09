#!/usr/bin/env bash

# Automated installer for ameliagapin/dotfiles using dotbot (anishathalye/dotbot)

function pecho() {
    local PRINT_COLOR=6
    if [[ ! -z "$2" ]] ; then
        PRINT_COLOR=$2
    fi

    echo -ne "$(tput setaf "${PRINT_COLOR}")$1$(tput sgr0)"
}

###############################################################################
# dotbot install
###############################################################################

pecho "Linking with dotbot:\n"

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

DOTBOT_DIR="dotbot"
DOTBOT_BIN="bin/dotbot"

cd "${BASEDIR}"

git submodule update --init --recursive "${DOTBOT_DIR}"
git submodule update --init --recursive "dotbot-brewfile"
git submodule update --init --recursive "dotbot-pip"
git submodule update --init --recursive "dotbot-yum"
git submodule update --init --recursive "dotbot-npm"
git submodule update --init --recursive "dotbot_plugin_aptget"

###############################################################################
# Link dotfiles
###############################################################################

CONFIG="install.conf.yaml"

pecho "Would you like to link dotfiles [y/N] "
read -r response ; tput sgr0
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]] ; then
    echo "Linking dotfiles:"

    "${BASEDIR}/${DOTBOT_DIR}/${DOTBOT_BIN}" -d "${BASEDIR}" -c "${CONFIG}" "${@}"
fi


pecho "Would you like to link bitly dotfiles [y/N] "
read -r response ; tput sgr0
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]] ; then
    echo "Linking bitly dotfiles:"

    CONFIG="install_bitly.conf.yaml"

    "${BASEDIR}/${DOTBOT_DIR}/${DOTBOT_BIN}" -d "${BASEDIR}" -c "${CONFIG}" "${@}"
fi


###############################################################################
# Install brew + formulae (macOS only)
###############################################################################

if [[ "$OSTYPE" =~ ^darwin ]] ; then
    CONFIG="brew.conf.yaml"

    ## install homebrew + formulae?
    pecho "Would you like to install Homebrew (http://brew.sh/) + my formulae? [y/N] "
    read -r response ; tput sgr0
    if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]] ; then

        echo "Installing brew:"

        # brew installed?
        which -s brew
        if [[ $? != 0 ]] ; then
            # install Homebrew
            echo "Installing brew:"
            ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
        else
            echo "Brew already installed. Let's make sure your formulae are up to date:"
            brew update
            brew upgrade
        fi

        pecho "Would you like to install Mac App Store apps [y/N] "
        read -r response ; tput sgr0
        if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]] ; then
            # Have to install mas so we can do the signin
            brew install mas

            pecho "What is you iCloud account email address? "
            read -r response ; tput sgr0
            mas signin $response
        fi

        echo "Installing (z, fzf, thefuck, etc...):"

        # Double check we've installed brew correctly
        if command -v brew >/dev/null 2>&1 ; then
          echo "Installing brew formulae:"

          "${BASEDIR}/${DOTBOT_DIR}/${DOTBOT_BIN}" -d "${BASEDIR}" --plugin-dir dotbot-brewfile -c "${CONFIG}" "${@}"
        else
            echo "Error installing brew... brew + packages not installed."
        fi
    fi
fi

###############################################################################
# Set macOS System Prefs
###############################################################################

if [[ "$OSTYPE" =~ ^darwin ]] ; then
    pecho "Would you like to set your computer name (as done via System Preferences >> Sharing)?  (y/n)"
    read -r response ; tput sgr0
    if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
      pecho "What would you like it to be?"
      read COMPUTER_NAME
      sudo scutil --set ComputerName $COMPUTER_NAME
      sudo scutil --set HostName $COMPUTER_NAME
      sudo scutil --set LocalHostName $COMPUTER_NAME
      sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string $COMPUTER_NAME
    fi

    pecho "Would you like to set macOS prefs [y/N] "
    read -r response ; tput sgr0
    if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]] ; then
        source macos
    fi
fi


###############################################################################
# Install yum packages
###############################################################################

YUM_CMD=$(which yum)
if [[ ! -z $YUM_CMD ]] ; then
    CONFIG="yum.conf.yaml"

    pecho "Would you like to install yum packages [y/N] "
    read -r response ; tput sgr0
    if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]] ; then
        echo "Installing yum packages:"

        # Need to add this repo for vim8
        curl -L https://copr.fedorainfracloud.org/coprs/mcepl/vim8/repo/epel-7/mcepl-vim8-epel-7.repo -o /etc/yum.repos.d/mcepl-vim8-epel-7.repo

        # Need to add this repo for node
        curl -sL https://rpm.nodesource.com/setup_6.x | sudo -E bash -

        # Python3
        sudo yum -y install https://centos7.iuscommunity.org/ius-release.rpm

        # Yarn
        curl -sL https://dl.yarnpkg.com/rpm/yarn.repo -o /etc/yum.repos.d/yarn.repo

        "${BASEDIR}/${DOTBOT_DIR}/${DOTBOT_BIN}" -d "${BASEDIR}" -p dotbot-yum/yum.py -c "${CONFIG}" "${@}"
    fi
fi

###############################################################################
# Install apt-get packages
###############################################################################

APT_GET_CMD=$(which apt-get)

if [[ ! -z $APT_GET_CMD ]] ; then
    CONFIG="aptget.conf.yaml"

    pecho "Would you like to install apt-get packages [y/N] "
    read -r response ; tput sgr0
    if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]] ; then
        echo "Installing apt-get packages:"

        "${BASEDIR}/${DOTBOT_DIR}/${DOTBOT_BIN}" -d "${BASEDIR}" -p dotbot_plugin_aptget/aptget.py -c "${CONFIG}" "${@}"
    fi
fi

###############################################################################
# Install pip packages
###############################################################################

CONFIG="pip.conf.yaml"

pecho "Would you like to install pip packages? [y/N] "
read -r response ; tput sgr0
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]] ; then
    echo "Installing pip packages:"
    "${BASEDIR}/${DOTBOT_DIR}/${DOTBOT_BIN}" -d "${BASEDIR}" --plugin-dir dotbot-pip -c "${CONFIG}" "${@}"
fi

###############################################################################
# Install npm packages
###############################################################################

CONFIG="npm.conf.yaml"

pecho "Would you like to install npm packages? [y/N] "
read -r response ; tput sgr0
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]] ; then
    echo "Installing npm packages:"
    "${BASEDIR}/${DOTBOT_DIR}/${DOTBOT_BIN}" -d "${BASEDIR}" --plugin-dir dotbot-npm -c "${CONFIG}" "${@}"
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

    vim +PlugClean +PlugInstall +qall

    mkdir -p ~/.vim/undo
fi

###############################################################################
# Powerline fonts
###############################################################################

pecho "Would you like to install powerline fonts (for vim-airline)? [y/N] "
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]] ; then
    cd ~/.vim/plugged/powerline-fonts
    ./install.sh
fi

###############################################################################
# Make sure the latest version of bash is being used
###############################################################################

pecho "Would you like to ensure latest version bash [y/N] "
read -r response ; tput sgr0
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]] ; then
    sudo bash -c 'echo /usr/local/bin/bash >> /etc/shells'
    chsh -s /usr/local/bin/bash
fi

###############################################################################
# Finish
###############################################################################

pecho "Done!"

