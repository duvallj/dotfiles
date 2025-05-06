if [[ -d /opt/homebrew ]]; then
  export PATH="${PATH}:/opt/homebrew/bin"
fi

eval "$(brew shellenv)"
export PATH="$(brew --prefix)/opt/mysql-client@8.0/bin:${PATH}"
alias my="mysql -u root -h 127.0.0.1"

eval "$(mise activate zsh)"
export PATH="${HOME}/.local/bin:${PATH}"
# go path automatically managed by mise

export WONDER_ROOT="${HOME}/wonder/src"
export CROAM_ENV="local"
source "${HOME}/wonder-aliases.sh"
