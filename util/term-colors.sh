#!/bin/bash

set -e

# http://www.linuxcommand.org/lc3_adv_tput.php
# https://unix.stackexchange.com/questions/269077/tput-setaf-color-table-how-to-determine-color-codes

if which tput >/dev/null 2>&1; then
  ncolors=$(tput colors)
fi

if [ -t 1 ] && [ -n "$ncolors" ] && [ "$ncolors" -ge 16 ]; then
  normal="$(tput sgr0)"
  bold="$(tput bold)"
  black="$(tput setaf 0)"
  red="$(tput setaf 1)"
  green="$(tput setaf 2)"
  yellow="$(tput setaf 3)"
  blue="$(tput setaf 4)"
  magenta="$(tput setaf 5)"
  cyan="$(tput setaf 6)"
  white="$(tput setaf 7)"
  lightblack="$(tput setaf 8)"
  lightred="$(tput setaf 9)"
  lightgreen="$(tput setaf 10)"
  lightyellow="$(tput setaf 11)"
  lightblue="$(tput setaf 12)"
  lightmagenta="$(tput setaf 13)"
  lightcyan="$(tput setaf 14)"
  lightwhite="$(tput setaf 15)"
  onblack="$(tput setab 0)"
  onred="$(tput setab 1)"
  ongreen="$(tput setab 2)"
  onyellow="$(tput setab 3)"
  onblue="$(tput setab 4)"
  onmagenta="$(tput setab 5)"
  oncyan="$(tput setab 6)"
  onwhite="$(tput setab 7)"
  onlightblack="$(tput setab 8)"
  onlightred="$(tput setab 9)"
  onlightgreen="$(tput setab 10)"
  onlightyellow="$(tput setab 11)"
  onlightblue="$(tput setab 12)"
  onlightmagenta="$(tput setab 13)"
  onlightcyan="$(tput setab 14)"
  onlightwhite="$(tput setab 15)"
elif [ -t 1 ] && [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
  normal="$(tput sgr0)"
  bold="$(tput bold)"
  black="$(tput setaf 0)"
  red="$(tput setaf 1)"
  green="$(tput setaf 2)"
  yellow="$(tput setaf 3)"
  blue="$(tput setaf 4)"
  magenta="$(tput setaf 5)"
  cyan="$(tput setaf 6)"
  white="$(tput setaf 7)"
  lightblack=black
  lightred=red
  lightgreen=green
  lightyellow=yellow
  lightblue=blue
  lightmagenta=magenta
  lightcyan=cyan
  lightwhite=white
  onblack="$(tput setab 0)"
  onred="$(tput setab 1)"
  ongreen="$(tput setab 2)"
  onyellow="$(tput setab 3)"
  onblue="$(tput setab 4)"
  onmagenta="$(tput setab 5)"
  oncyan="$(tput setab 6)"
  onwhite="$(tput setab 7)"
  onlightblack=onblack
  onlightred=onred
  onlightgreen=ongreen
  onlightyellow=onyellow
  onlightblue=onblue
  onlightmagenta=onmagenta
  onlightcyan=oncyan
  onlightwhite=onwhite
else
  normal=""
  bold=""
  black=""
  red=""
  green=""
  yellow=""
  blue=""
  magenta=""
  cyan=""
  white=""
  lightblack=""
  lightred=""
  lightgreen=""
  lightyellow=""
  lightblue=""
  lightmagenta=""
  lightcyan=""
  lightwhite=""
  onblack=""
  onred=""
  ongreen=""
  onyellow=""
  onblue=""
  onmagenta=""
  oncyan=""
  onwhite=""
  onlightblack=""
  onlightred=""
  onlightgreen=""
  onlightyellow=""
  onlightblue=""
  onlightmagenta=""
  onlightcyan=""
  onlightwhite=""
fi
