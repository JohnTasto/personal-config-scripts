export PATH="/usr/local/bin:$PATH"


[[ -e ~/.cross.bashrc ]] && source ~/.cross.bashrc
[[ -e ~/.cross.commonrc ]] && source ~/.cross.commonrc
[[ -e ~/.commonrc ]] && source ~/.commonrc


# Prompt
export PS1="\n\w/\n\$ > "


# chrome () {
#   /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome $* 2>&1 &
# }

# alias chromex="chrome --disable-web-security"

# # Use extended regex in sed and grep
# alias sed="sed -E"
# export GREP_OPTIONS="-E --color=auto"
