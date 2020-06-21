umask 022


[[ -e ~/.cross.zprofile ]] && source ~/.cross.zprofile
[[ -e ~/.cross.common_profile ]] && emulate sh -c 'source ~/.cross.common_profile'
[[ -e ~/.common_profile ]] && emulate sh -c 'source ~/.common_profile'
