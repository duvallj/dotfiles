##### NOTE: if you're on NixOS/nix-darwin, this is NOT USED!!! #####
##### See the respective home-manager config instead.          #####


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

# Get Powerlevel10k
source "${HOME}/powerlevel10k/powerlevel10k.zsh-theme"

# Source platform-specific variables
source "${HOME}/.zshrc.extra"

#End on lines added by me, the user

# To customize prompt, run `p10k configure` or edit ~/.zshrc.p10k.
[[ ! -f "${HOME}/.zshrc.p10k" ]] || source "${HOME}/.zshrc.p10k"
