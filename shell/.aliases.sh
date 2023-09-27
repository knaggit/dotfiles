#!/bin/bash

# Set svgo config
alias svgo="svgo --config=$HOME/.svgo.config.js"

# kubectl alias
alias kc="kubectl"

# exa alias
alias ls='exa     --icons --classify --group-directories-first'
alias ll='exa -l  --icons --classify --group-directories-first --header --group --created --modified --octal-permissions --time-style long-iso --git'
alias la='exa -la --icons --classify --group-directories-first --header --group --created --modified --octal-permissions --time-style long-iso --git'
alias lt='exa     --icons --classify --group-directories-first --tree --level=2'

# sed alias
alias sed='gsed'

# tar alias
alias tar='gtar'

# public wifi login
alias wifi='nextdns deactivate; open http://neverssl.com; read -P "Continue? "; nextdns activate'
