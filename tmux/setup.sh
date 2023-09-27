#!/bin/bash

tpm_root="$HOME/.tmux/plugins/tpm"

if [ -d "${tpm_root}" ] ; then
  exit
fi

git clone https://github.com/tmux-plugins/tpm $tpm_root
