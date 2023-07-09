alias net="${HOME}/.local/etc/rc/StartNetworking.sh"
alias o="xdg-open"
alias ki="kinit jrduvall"
alias icat="kitty +kitten icat"
alias reboot-windows="systemctl reboot --boot-loader-entry=windows.conf"

export PATH="$PATH:$HOME/.nix-profile/bin:$HOME/.cargo/bin"
export NIX_USER_CONF_FILES="$HOME/.config/nix.conf"

# opam configuration
[[ ! -r /home/polywolf/.opam/opam-init/init.zsh ]] || source /home/polywolf/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null

# oss-cad-suite
fpga() {
  source /opt/oss-cad-suite/environment
}

spectre() {
  TERM=xterm-256color ssh spectre
}

export PATH="$HOME/.local/bin:$PATH"
# export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$HOME/CMU/410-TA/simics6/simics-6-packages/simics-6.0.157/linux64/sys/lib"
# because simics wants an older libcrypt and python's cryptography library isn't happy with that
# export CRYPTOGRAPHY_OPENSSL_NO_LEGACY=1

[ -f "$HOME/.ghcup/env" ] && source "$HOME/.ghcup/env" # ghcup-env
