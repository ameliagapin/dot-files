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

CONFIG="install.conf.yaml"
DOTBOT_DIR="dotbot"
DOTBOT_BIN="bin/dotbot"

cd "${BASEDIR}"
git submodule update --init --recursive "${DOTBOT_DIR}"

"${BASEDIR}/${DOTBOT_DIR}/${DOTBOT_BIN}" -d "${BASEDIR}" -c "${CONFIG}" "${@}"

###############################################################################
# Install brew + formulae (macOS only)
###############################################################################

## abort if not macOS
[[ "$OSTYPE" =~ ^darwin ]] || exit 0

## install homebrew + formulae?
pecho "Would you like to install Homebrew (http://brew.sh/) + my formulae? [y/N] "
read -r response ; tput sgr0
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]] ; then
    echo "Installing brew and formulae (z, fzf, thefuck, etc...):"

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

    # Double check we've installed brew correctly
    if command -v brew >/dev/null 2>&1 ; then
      echo "Installing brew formulae:"

      brew install bash
      brew tap homebrew/versions
      brew install bash-completion2

      # Install GNU core utilities (those that come with macOS are outdated)
      # Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`
      brew install coreutils

      # Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
      brew install findutils

      # Install GNU `sed`, overwriting the built-in `sed`.
      brew install gnu-sed --with-default-names

      # Install `wget` with IRI support.
      brew install wget --with-iri

      # Install more recent versions of some macOS tools.
      brew install vim --override-system-vi
      brew install homebrew/dupes/grep --with-default-names
      brew install homebrew/dupes/openssh

      # You'll need to run through fzf's setup
      # Note: I've already added required configuration to ~/.extras
      brew install fzf
      # /usr/local/opt/fzf/install

      # Misc useful formulae (brew list -la | awk '{a="brew install "$9; print a}' | pbcopy)
      brew install ack
      brew install diff-so-fancy
      brew install findutils
      brew install fpp
      brew install gifsicle
      brew install git
      brew install git-extras
      brew install highlight
      brew install htop-osx
      brew install httpie
      brew install imagemagick --with-webp
      brew install lynx
      brew install mongodb
      brew install mysql
      brew install mycli
      brew install nmap
      brew install nvm
      brew install openssl
      brew install python
      brew install python3
      brew install ruby
      brew install sqlite
      brew install the_silver_searcher
      brew install thefuck
      brew install tig
      brew install tmux
      brew install tree
      brew install z

      brew cask install iterm2
      brew cask install google-chrome
      brew cask install coderunner
      brew cask install atom
      brew cask install mackdown
      brew cask install virtualbox
      brew cask install github

      brew cask install vagrant
      vagrant plugin install vagrant-s3auth
      vagrant plugin install vagrant-aws

      brew cask install macvim
      brew cask install macdown
      brew cask install dash
      brew cask install cheatsheat
      brew cask install rocket
      brew cask install dropbox
      brew cask install postman
      brew cask install google-drive-file-stream

      brew cleanup

    else
        echo "Error installing brew... brew + packages not installed."
    fi
fi

###############################################################################
# Install pip packages
###############################################################################

pecho "Would you like to install pip packages? [y/N] "
read -r response ; tput sgr0
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]] ; then
    echo "Installing pip packages:"
    pip install glances[action,browser,cloud,cpuinfo,chart,docker,export,folders,gpu,ip,raid,snmp,web,wifi]
fi

###############################################################################
# Install npm packages
###############################################################################

npm install -g tldr

###############################################################################
# Make sure the latest version of bash is being used
###############################################################################

sudo bash -c 'echo /usr/local/bin/bash >> /etc/shells'
chsh -s /usr/local/bin/bash

###############################################################################
# Update Vim plugins
###############################################################################

pecho "Cleaning/Installing/Updating Vim plugins:\n"

vim -E -s <<-EOF
    :source ~/.vimrc
    :PlugInstall
    :PlugClean
    :qa
EOF

# Compile YouCompleteMe
cd ~/.vim/plugged/youcompleteme
/usr/bin/python ./install.py --all

###############################################################################
# Powerline fonts
###############################################################################

pecho "Would you like to install powerline fonts (for vim-airline)? [y/N] "
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]
then
    source ./fonts/powerline-fonts/install.sh
else
    echo "Skipped installation of powerline fonts"
fi

###############################################################################
# Finish
###############################################################################

pecho "Done!" 2

###############################################################################
# TODO
###############################################################################

# TODO: Add for linux
# nodejs
# htop
# gtop
# bash_completion
# git
# nvm
# vim8 / vim-X11
# mycli

