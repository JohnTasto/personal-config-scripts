export PATH="/usr/local/bin:$PATH"

export HISTSIZE=10000                       # 500 is default
export HISTFILESIZE=1000000
export HISTTIMEFORMAT="%b %d %I:%M %p "     # using strftime format
export HISTCONTROL=ignoreboth               # ignoredups:ignorespace
export HISTIGNORE="history:pwd:exit:df:ls:ls -l:ls -la:ll"

# Prompt
export PS1="\n\w/\n\$ > "


chrome () {
  /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome $* 2>&1 &
}

alias chromex="chrome --disable-web-security"

# Sublime Text
export EDITOR='subl --new-window --wait'
alias st="subl"

# Safe file operations
alias mv="mv -i"
alias cp="cp -i"
#alias rm="rm -i"        # Takes way too long
alias mkdir="mkdir -p"

# Shortcuts
alias ll="ls -la"
alias cd..="cd .."
alias ..="cd .."
alias ~="cd ~"
alias .="pwd"

# Use extended regex in sed and grep
alias sed="sed -E"
export GREP_OPTIONS="-E --color=auto"

[[ -e ~/.sharedrc ]] && source ~/.sharedrc
