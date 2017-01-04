# load .bashrc on first terminal window launch (auto in subshells)
if [ -f ~/.bashrc ]; then
	source ~/.bashrc
fi

test -e ${HOME}/.iterm2_shell_integration.bash && source ${HOME}/.iterm2_shell_integration.bash
