#!/bin/bash

# reset from scratch:
#   win $  wsl --unregister Ubuntu-20.04
#   <launch Ubuntu-20.04, enter new username/password>
#   wsl >  exit
#   win $  wsl --setdefault Ubuntu-20.04
#   wsl >  sudo bash ubuntu2004-wsl2-setup.sh
#   wsl >  exit
#   win $  wsl --terminate Ubuntu-20.04
#   win $  wsl --distribution Ubuntu-20.04
#   wsl >  sudo bash ubuntu2004-wsl2-setup.sh

set -e

umask 022

source util/term-colors.sh

if ((${EUID:-0} || "$(id -u)")); then
  >&2 printf "${red}This script must be run as root.${normal}\n"
  exit 1
fi

user=${SUDO_USER:-$whoami}
home=$(getent passwd $user | cut -d: -f6)


if [[ ! -e /etc/wsl.conf ]]; then

  cp ./ubuntu2004-wsl2-setup/wsl.conf /etc/wsl.conf
  chmod 644 /etc/wsl.conf

  cp ./ubuntu2004-wsl2-setup/fstab /etc/fstab
  chmod 644 /etc/fstab

  cp ./ubuntu2004-wsl2-setup/setdns.sh /usr/local/bin/setdns
  chmod 755 /usr/local/bin/setdns

  printf "${green}WSL needs to be restarted to load its updated configuration.${normal}\n"
  printf "In Windows:\n"
  printf "  > ${lightyellow}wsl ${lightblack}--terminate ${normal}Ubuntu-20.04\n"
  printf "Then start Ubuntu-20.04 back up and rerun this script to continue.\n"

  exit 0

fi


setdns

printf "${green}Updating system...${normal}\n"
apt-get update
apt-get upgrade -y

printf "${green}Installing Zsh...${normal}\n"
apt-get install -y zsh  # fonts-powerline
chsh -s $(which zsh) $user
sudo -u $user sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh) --unattended"

printf "${green}Installing word list (i.e., /usr/share/dict/words)...${normal}\n"
apt-get install -y wamerican

printf "${green}Installing Lisp (sbcl)...${normal}\n"
apt-get install -y sbcl

printf "${green}Installing Haskell Stack...${normal}\n"
apt-get install -y haskell-stack
stack upgrade --binary-only

printf "${green}Installing Node...${normal}\n"
sudo -u $user bash -c "$(curl -fsS https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh)"
NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${home}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
sudo -u $user bash -c "[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && nvm install --lts --latest-npm node"

printf "${green}Installing Node tools (yarn and ts-node)...${normal}\n"
sudo -u $user bash -c "[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && npm install --global yarn ts-node"

printf "${green}Installing networking utilities...${normal}\n"
apt-get install -y whois net-tools
# apt-get install -y sysstat iputils-clockdiff traceroute  # doesn't work on WSL

printf "${green}Installing Python 2 (required by ssh-ident)...${normal}\n"
apt-get install -y python

printf "${green}Installing ssh-ident...${normal}\n"
# also requires BINARY_SSH="/usr/bin/ssh.original"
dpkg-divert --divert /usr/bin/ssh.original --rename /usr/bin/ssh
curl -fsSL goo.gl/MoJuKB > /usr/bin/ssh
chmod 0755 /usr/bin/ssh

printf "${green}Installing chezmoi...${normal}\n"
sudo -u $user sh -c "$(curl -fsSL https://git.io/chezmoi)"
mv ./bin "$home/bin"
sudo -u $user mkdir -p "$home/.config/zsh/completions" "$home/.config/bash/completions"
"${home}/bin/chezmoi" completion zsh --output "$home/.config/zsh/completions/chezmoi.zsh"
"${home}/bin/chezmoi" completion bash --output "$home/.config/bash/completions/chezmoi.bash"
sudo -u $user "${home}/bin/chezmoi" init https://github.com/JohnTasto/dotfiles.git
pushd "$home/.local/share/chezmoi"
git remote set-url origin git@github.com:JohnTasto/dotfiles.git
popd
apt-get install -y lastpass-cli

printf "${green}Now run:${normal}\n"
printf "  > lpass login <email>\n"
printf "  > ~/bin/chezmoi diff\n"
printf "  > ~/bin/chezmoi apply\n"
printf "${green}to generate dotfiles, then:${normal}\n"
printf "  > env zsh --login\n"
printf "${green}to start zsh!${normal}\n"
