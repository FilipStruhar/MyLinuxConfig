# Use Antigen
source ~/.antigen.zsh

# Use Oh My Zsh framework
antigen use oh-my-zsh

# Load plugins
antigen bundle git
antigen bundle aubreypwd/zsh-plugin-reload
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle dirhistory
antigen bundle sudo
antigen bundle copybuffer

# Robbyrussel theme
antigen theme robbyrussell
#Starship pure prompt theme
#eval "$(starship init zsh)"

# Apply Antigen
antigen apply


# Aliasses
alias ll='ls -la'

export PATH="$HOME/bin:$PATH"
