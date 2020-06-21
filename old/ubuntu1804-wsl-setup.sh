#!/bin/bash

# reset from scratch:
#   win $  wslconfig /unregister Ubuntu-18.04
#   <in Windows, launch Ubuntu-18.04, enter new username/password>
#   wsl >  exit
#   win $  wslconfig /setdefault Ubuntu-18.04
#   wsl >  sudo bash wsl-setup.sh
#   wsl >  exit
#   win $  net stop LxssManager
#   win $  net start LxssManager
#   wsl >  sudo bash wsl-setup.sh

set -e

umask 022

source ../util/term-colors.sh

if ((${EUID:-0} || "$(id -u)")); then
  printf "${red}This script must be run as root.${normal}\n" 1>&2
  exit 1
fi

user=${SUDO_USER:-$whoami}

if [[ ! -e /etc/wsl.conf ]]; then

  exec 3>&1
  exec > /etc/wsl.conf
  echo '[automount]'
  echo 'root = /'
  echo 'options = "metadata,uid=1000,gid=1000,umask=022,fmask=111"'
  # exec >> /etc/sysctl.conf
  # echo ''
  # echo 'net.ipv6.conf.all.disable_ipv6 = 1'
  # echo 'net.ipv6.conf.default.disable_ipv6 = 1'
  # echo 'net.ipv6.conf.lo.disable_ipv6 = 1'
  exec 1>&3

  printf "${green}WSL configuration changed.${normal}\n\n"
  printf "Restart WSL by restarting the Windows LxssManager service.\n"
  printf "E.g., in an administrator cmd.exe:\n\n"
  printf "  $ net stop LxssManager\n"
  printf "  $ net start LxssManager\n\n"
  printf "Then rerun this script to continue.\n"

  exit 0

fi

printf "${green}Setting up dbus...${normal}\n"
# https://www.reddit.com/r/bashonubuntuonwindows/comments/9lpc0o/ubuntu_1804_dbus_fix_instructions_with/
# Try 1:
# echo "<listen>tcp:host=localhost,port=0</listen>" > /etc/dbus-1/session-local.conf  # more errors!
# Try 2:
# exec 3>&1
# exec > /etc/dbus-1/session-local.conf
# echo '<!DOCTYPE busconfig PUBLIC "-//freedesktop//DTD D-Bus Bus Configuration 1.0//EN"'
# echo ' "http://www.freedesktop.org/standards/dbus/1.0/busconfig.dtd">'
# echo '<busconfig>'
# echo '  <listen>tcp:host=localhost,port=0</listen>'
# echo '</busconfig>'
# exec 1>&3
# Try 3:
# sed -r -i.bak 's$(<(listen)>).*(</\2>)$\1tcp:host=localhost,port=0\3$' /usr/share/dbus-1/session.conf
systemd-machine-id-setup
service dbus start

printf "${green}Updating system...${normal}\n"
apt-get update
apt-get upgrade -y

# printf "${green}Installing desktop apps...${normal}\n"
# apt-get install -y ubuntu-desktop
#
# # make sure it is still up
# service dbus start

printf "${green}Installing GUI apps...${normal}\n"
apt-get install -y dbus-x11 gedit gedit-plugins nautilus gitg

printf "${green}Fixing some Nautilus errors...${normal}\n"
# chown $user:$user ~/.cache           # only needed for ubuntu-desktop
sudo -u $user touch ~/.gtk-bookmarks
sudo -u $user mkdir -p ~/.config/nautilus
# mkdir -p /var/lib/samba/usershares/  # only needed for ubuntu-desktop

# printf "${green}Installing themepicker...${normal}\n"
# apt-get install -y lxappearance
# apt-get install -y gnome-themes-extra light-themes
# apt-get install -y gnome-icon-theme breeze-icon-theme, gnome-icon-theme-gartoon-redux, tango-icon-theme
# apt-get install -y dmz-cursor-theme xcursor-themes

printf "${green}Installing themes...${normal}\n"
apt-get install -y gnome-themes-extra gnome-icon-theme dmz-cursor-theme

printf "${green}Setting up theme...${normal}\n"
# fix gitg diff colors: gtk-application-prefer-dark-theme=true
exec 3>&1
sudo -u $user mkdir -p ~/.config/gtk-3.0
exec > ~/.config/gtk-3.0/settings.ini
chown $user:$user ~/.config/gtk-3.0/settings.ini
echo '[Settings]'
echo 'gtk-theme-name=Adwaita-dark'
echo 'gtk-icon-theme-name=gnome'
echo 'gtk-font-name=Sans 10'
echo 'gtk-cursor-theme-name=DMZ-White'
echo 'gtk-cursor-theme-size=0'
echo 'gtk-toolbar-style=GTK_TOOLBAR_BOTH'
echo 'gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR'
echo 'gtk-button-images=1'
echo 'gtk-menu-images=1'
echo 'gtk-enable-event-sounds=1'
echo 'gtk-enable-input-feedback-sounds=1'
echo 'gtk-xft-antialias=1'
echo 'gtk-xft-hinting=1'
echo 'gtk-xft-hintstyle=hintfull'
# echo 'gtk-xft-rgba=rgb'
# echo 'gtk-modules=gail:atk-bridge'
echo 'gtk-application-prefer-dark-theme=true'
exec > ~/.gtkrc-2.0
chown $user:$user ~/.gtkrc-2.0
echo 'include "/home/john/.gtkrc-2.0.mine"'
echo 'gtk-theme-name="Adwaita-dark"'
echo 'gtk-icon-theme-name="gnome"'
echo 'gtk-font-name="Sans 10"'
echo 'gtk-cursor-theme-name="DMZ-White"'
echo 'gtk-cursor-theme-size=0'
echo 'gtk-toolbar-style=GTK_TOOLBAR_BOTH'
echo 'gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR'
echo 'gtk-button-images=1'
echo 'gtk-menu-images=1'
echo 'gtk-enable-event-sounds=1'
echo 'gtk-enable-input-feedback-sounds=1'
echo 'gtk-xft-antialias=1'
echo 'gtk-xft-hinting=1'
echo 'gtk-xft-hintstyle="hintfull"'
# echo 'gtk-xft-rgba="rgb"'
# echo 'gtk-modules="gail:atk-bridge"'
exec > ~/.gtkrc-2.0.mine
chown $user:$user ~/.gtkrc-2.0.mine
echo 'gtk-application-prefer-dark-theme=true'
exec 1>&3

printf "${green}Installing Nix...${normal}\n"
# there is a more secure way to install but requires exact version numbers
curl -L https://nixos.org/nix/install | sh
if [ -e /home/john/.nix-profile/etc/profile.d/nix.sh ]; then
  . /home/john/.nix-profile/etc/profile.d/nix.sh;
fi

printf "${green}Installing Zsh...${normal}\n"
apt-get install -y zsh  # fonts-powerline
chsh -s $(which zsh) $user
sudo -u $user sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sed -e '/^\s*env\s\+zsh\s*/d' -e '/^\s*chsh\s\+-s\s*/d')"

printf "${green}Installing word list (i.e., /usr/share/dict/words)...${normal}\n"
apt-get install -y wamerican

printf "${green}Installing Lisp (sbcl)...${normal}\n"
apt-get install -y sbcl

printf "${green}Installing Haskell Stack...${normal}\n"
apt-get install -y haskell-stack
# not sure if the following needs sudo:
# stack upgrade --binary-only

# printf "${green}Installing Haskell IDE Engine...${normal}\n"
# didn't work from command line, maybe needs sudo
# nix-env -iA selection --arg selector 'p: { inherit (p) ghc864 ghc863 ghc843; }' -f https://github.com/infinisil/all-hies/tarball/master

printf "${green}Installing Node...${normal}\n"
sudo -u $user bash -c "$(curl -fsS https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh)"
sudo -u $user bash -c "source "$HOME"/.nvm/nvm.sh; nvm install --lts --latest-npm node"

printf "${green}Installing Yarn...${normal}\n"
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list
apt-get update && apt-get install -y --no-install-recommends yarn

# printf "${green}Installing Puppeteer/Chrome dependencies...${normal}\n"
# apt-get install -y libxss1 libasound2

printf "${green}Installing networking utilities...${normal}\n"
apt-get install -y whois
# apt-get install -y sysstat iputils-clockdiff traceroute  # doesn't work on WSL

printf "${green}Installing Docker...${normal}\n"
apt-get install -y apt-transport-https ca-certificates software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
apt-key fingerprint 0EBFCD88
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update
apt-get install -y docker-ce   # docker-ce-cli containerd.io
usermod -aG docker $user

printf "${green}Installing docker-compose...${normal}\n"
apt-get install -y python python-pip
sudo -u $user pip install --user docker-compose

printf "${green}Installing ssh-ident...${normal}\n"
# also requires BINARY_SSH="/usr/bin/ssh.original"
dpkg-divert --divert /usr/bin/ssh.original --rename /usr/bin/ssh
curl -fsSL goo.gl/MoJuKB > /usr/bin/ssh
chmod 0755 /usr/bin/ssh

printf "${green}Linking dotfiles...${normal}\n"
sudo -u $user bash ./dotfiles/link-dotfiles.sh wsl cross

printf "${green}Fixing permissions...${normal}\n"
shopt -s globstar
chmod u=rwX,go= -R ~/.ssh
chmod go+r ~/.ssh/**/*.pub
chmod go-r ~/.bash_history ~/.zsh_history
shopt -u globstar

printf "${green}Setting up Docker TLS...${normal}\n"
sudo -u $user bash wsl-docker/refresh-certs.sh

printf "${green}Switching to Zsh...${normal}\n"
sudo -u $user env zsh -l
