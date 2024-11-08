alias my="mysql -u root -h 127.0.0.1"

if [[ -d /opt/homebrew ]]; then
  export PATH="${PATH}:/opt/homebrew/bin"
fi

eval "$(brew shellenv)"
export PATH="$(brew --prefix)/opt/mysql-client@8.0/bin:${PATH}"

export WONDER_ROOT="${HOME}/wonder/src"
export CROAM_ENV="local"
source "${HOME}/wonder-aliases.sh"

source "$(brew --prefix)/opt/asdf/libexec/asdf.sh"
export PATH="${HOME}/.local/bin:$(go env GOPATH)/bin:${PATH}"

