if [[ -d /opt/homebrew ]]; then
  export PATH="${PATH}:/opt/homebrew/bin"
fi

eval "$(brew shellenv)"
brew_prefix="$(brew --prefix)"
export PATH="${brew_prefix}/opt/mysql-client@8.0/bin:${PATH}"
export PKG_CONFIG_PATH="${PKG_CONFIG_PATH}${PKG_CONFIG_PATH:+:}${brew_prefix}/lib/pkgconfig"
alias my="mysql -u root -h 127.0.0.1"

eval "$(mise activate zsh)"
export PATH="${HOME}/.local/bin:${PATH}"
# go path automatically managed by mise

export WONDER_ROOT="${HOME}/wonder/src"
export CROAM_ENV="local"
source "${HOME}/wonder-aliases.sh"

function kill-mysql {
  # this sucks
  brew services stop mysql@8.0
  ps aux | grep mysql | grep -v grep | awk '{ print $2; }' | xargs kill -9
  brew services start mysql@8.0
}

function goinstall {
  go install golang.org/x/tools/gopls@latest
  go install github.com/go-delve/delve/cmd/dlv@latest
}
