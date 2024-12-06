# Required  to get some extra defaults from WTO's default .zshrc
source /tmp/initial_config/.zshrc

# User's personal ZSHRC goes below

## Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory autocd extendedglob notify
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/user/.zshrc'

autoload -Uz compinit
compinit
## End of lines added by compinstall

## Alias
## Cat alias
alias cat="bat -p"

## Grep alias (ripgrep)
alias grep="rg"

## Oh My ZSH
# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"
# Set ZSH theme
ZSH_THEME="avit"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

