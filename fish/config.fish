set fish_greeting
set sponge_purge_only_on_exit true

# Set PATH and environment
bass source ~/.env.sh

# Set aliases
source ~/.aliases.sh

# Init starship
starship init fish | source

# Enable iTerm2 shell integration
source ~/.iterm2_shell_integration.fish
