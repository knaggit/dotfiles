# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/zshrc.pre.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.pre.zsh"

# Load Antidote
source $HOMEBREW_PREFIX/opt/antidote/share/antidote/antidote.zsh
source ~/.zsh_plugins.zsh

# Ignore commands in history that begin with a space
# https://dev.to/epranka/hide-the-exported-env-variables-from-the-history-49ni
export HISTCONTROL=ignorespace

# Set PATH and environment
source ~/.env.sh

# Set aliases
source ~/.aliases.sh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh
# Enable fuzzy history search
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Enable iTerm2 shell integration
source ~/.iterm2_shell_integration.zsh

# Init starship
eval "$(starship init zsh)"

# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/zshrc.post.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.post.zsh"
