# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

ZSH_ROOT="${HOME}/.zsh_config"

# Lines configured by zsh-newuser-install
HISTFILE="$ZSH_ROOT/.zsh_history"
HISTSIZE=1000
SAVEHIST=1000
setopt notify
unsetopt beep
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename "$(dirname $ZSH_ROOT)/.zshrc"

autoload -Uz compinit
SHORT_HOST=${HOST/.*/}
compinit -d "${ZSH_ROOT}/.zcompdump-${SHORT_HOST}-${ZSH_VERSION}"
# End of lines added by compinstall
# Lines configured by me, the user

source "${HOME}/.extra-archlinux.zsh"

# Get 256 color
#export TERM='tmux-256color'

# Get Powerlevel10k
# source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
source "${HOME}/powerlevel10k/powerlevel10k.zsh-theme"

# Set path
export PATH=/home/me/.local/bin:$PATH

# Configure aliases 
alias ls="ls --color=auto"
alias la="ls -la"

#End on lines added by me, the user
 

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
