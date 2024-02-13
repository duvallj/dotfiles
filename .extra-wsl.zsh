export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export GPG_TTY="tty"

if [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then . "$HOME/.nix-profile/etc/profile.d/nix.sh"; fi # added by Nix installer

# opam configuration
test -r /home/me/.opam/opam-init/init.zsh && . /home/me/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true

# extra programs
export PATH="${PATH}:/usr/lib/cargo/bin:${HOME}/.local/bin"

alias ls="ls --color=auto"
alias la="ls -la"
