umask 022


[[ -e ~/.cross.bash_profile ]] && source ~/.cross.bash_profile
[[ -e ~/.cross.common_profile ]] && source ~/.cross.common_profile
[[ -e ~/.common_profile ]] && source ~/.common_profile


if [ -f "$HOME/.bashrc" ]; then
  . "$HOME/.bashrc"
fi
