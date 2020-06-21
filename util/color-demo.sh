#!/bin/bash

for fg_color in {0..15}; do
  set_foreground=$(tput setaf $fg_color)
  for bg_color in {0..15}; do
    set_background=$(tput setab $bg_color)
    echo -n $set_background$set_foreground
    printf ' %2u on %u ' $fg_color $bg_color
  done
  echo $(tput sgr0)
done
