# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
umask 022

# moved to .bash_profile, where check is not required
# # if running bash
# if [ -n "$BASH_VERSION" ]; then
#   # include .bashrc if it exists
#   if [ -f "$HOME/.bashrc" ]; then
# 	  . "$HOME/.bashrc"
#   fi
# fi

# moved to .common_profile
# # set PATH so it includes user's private bin if it exists
# if [ -d "$HOME/bin" ]; then
#   PATH="$HOME/bin:$PATH"
# fi
#
# # set PATH so it includes user's private bin if it exists
# if [ -d "$HOME/.local/bin" ]; then
#   PATH="$HOME/.local/bin:$PATH"
# fi


[[ -e ~/.cross.profile ]] && source ~/.cross.profile
[[ -e ~/.cross.common_profile ]] && source ~/.cross.common_profile
[[ -e ~/.common_profile ]] && source ~/.common_profile
