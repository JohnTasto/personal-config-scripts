#!/bin/bash

set -e

# TODO:
# install Atom packages and link settings
# install VSCode packages and link settings


read -s -p "Enter password: " PASSWORD


# Increase maximum number of open files

echo $PASSWORD | sudo -S launchctl limit maxfiles unlimited


echo "Installing command line tools..."
xcode-select --install


echo "Installing Oh My Zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
chsh -s $(which zsh)


echo "Installing Homebrew..."
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew update


# Homebrew command line utilities

echo "Installing wget..."
brew install wget

echo "Installing git..."
brew install git

echo "Installing ruby..."
brew install ruby

echo "Installing elixir..."
brew install elixir

echo "Installing AWS tools..."
brew install awscli  # amazon-ecs-cli

echo "Installing dos2unix..."
brew install dos2unix

echo "Installing tree..."
brew install tree


# Homebrew GUI applications

echo "Installing Docker for Mac..."
brew cask install docker

echo "Installing Virtualbox..."
brew cask install virtualbox

echo "Installing Vagrant..."
brew cask install vagrant
vagrant plugin install vagrant-vbguest

echo "Installing iTerm2..."
brew cask install iterm2

echo "Installing Atom..."
brew cask install atom

echo "Installing Visual Studio Code..."
brew cask install visual-studio-code

echo "Installing Slack..."
brew cask install slack

echo "Installing BeardedSpice..."
brew cask install beardedspice

echo "Installing BetterTouchTool..."
brew cask install bettertouchtool

echo "Installing MacTeX..."
brew cask install mactex


# Python

echo "Installing Miniconda..."
brew cask install miniconda

echo "Installing Conda packages..."
conda install \
  jupyter \
  matplotlib \
  numpy \
  pandas \
  scikit-learn \
  scipy \
  seaborn

echo "Installing Python packages..."
pip install csvkit


echo "Installing Ansible..."
conda create --name ansible python=2.7
source activate ansible
pip install ansible boto boto3 awscli
source deactivate


# Node

echo "Installing Node (through NVM)..."
brew install nvm
nvm install node

echo "Installing Yarn..."
brew install yarn

echo "Installing npm packages..."
npm i -g \
  eslint \
  jshint \
  now \
  nowrm \
  typings


# Misc

echo "Installing Travis..."
gem install travis


# Mongo
# figure out how to do this in Docker

# echo "Installing MongoDB..."
# brew install mongo
# echo $PASSWORD | sudo -S mkdir -p /data/db
# echo $PASSWORD | sudo -S chown -R $USER /data/db
# brew services start mongo


# PostgreSQL
# figure out how to do this in Docker

# echo "Installing PostgreSQL..."
# brew install postgresql
# brew install pgadmin4
# brew install postgis
# brew install pgrouting
#
# plpython???


echo "Linking dotfiles to "$HOME"..."

if [ -e dotfiles.bak ]; then
  rm -rf dotfiles.bak
fi
mkdir dotfiles.bak

DOTFILES=$(ls -A1 dotfiles | grep -E '^\.\S')

for DOTFILE in $DOTFILES; do
  echo "$HOME/$DOTFILE"
  if [ -e "$HOME/$DOTFILE" ]; then
    mv "$HOME/$DOTFILE" "dotfiles.bak/$DOTFILE"
  else
    rm -rf "$HOME/$DOTFILE"
  fi
  ln -s "$(pwd)/dotfiles/$DOTFILE" "$HOME/$DOTFILE"
done

echo "Original dotfiles are located in $(pwd)/dotfiles.bak/."
