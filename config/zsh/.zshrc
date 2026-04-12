source "$HOME/.config/zsh/environment.zsh"
[ -f "$HOME/.config/zsh/secret.zsh" ] && source $HOME/.config/zsh/secret.zsh

MY_PLUGIN_PATH="$HOME/.config/zsh/plugins"
# Completions
FPATH="$HOME/.config/zsh/.zfunc:$FPATH"
source "$MY_PLUGIN_PATH/zsh-completions/zsh-completions.plugin.zsh"

# Enable completion
autoload bashcompinit && bashcompinit # for support bash style completion
autoload -Uz compinit && compinit     # U: autoload, z: autoload completion functions
# complete -C "$(which aws_completer)" aws # this is bash style completion

# Plugins
source "$MY_PLUGIN_PATH/zsh-history-substring-search/zsh-history-substring-search.plugin.zsh"
source "$MY_PLUGIN_PATH/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh"
source "$MY_PLUGIN_PATH/fast-syntax-highlighting/F-Sy-H.plugin.zsh"
source "$MY_PLUGIN_PATH/zsh-autopair/zsh-autopair.plugin.zsh"
source "$MY_PLUGIN_PATH/zsh-vi-mode/zsh-vi-mode.plugin.zsh"
source "$MY_PLUGIN_PATH/fzf-tab/fzf-tab.plugin.zsh"

# Run third-party tools
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
else
  log_warning "missing zoxide"
fi
if command -v fzf &>/dev/null; then
  eval "$(fzf --zsh)"
else
  log_warning "missing fzf"
fi
if command -v direnv &>/dev/null; then
  eval "$(direnv hook zsh)"
else
  log_warning "missing direnv"
fi
if command -v starship &>/dev/null; then
  eval "$(starship init zsh)"
else
  log_warning "missing starship"
fi

# Aliases and functions
source "$HOME/.config/zsh/alias.zsh"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
