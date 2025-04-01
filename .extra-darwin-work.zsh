alias my="mysql -u root -h 127.0.0.1"

if [[ -d /opt/homebrew ]]; then
  export PATH="${PATH}:/opt/homebrew/bin"
fi

eval "$(brew shellenv)"
export PATH="$(brew --prefix)/opt/mysql-client@8.0/bin:${PATH}"

export ASDF_DATA_DIR="${HOME}/.asdf"
export PATH="${ASDF_DATA_DIR}/shims:${PATH}"
export PATH="${HOME}/.local/bin:$(go env GOPATH)/bin:${PATH}"

export WONDER_ROOT="${HOME}/wonder/src"
export CROAM_ENV="local"
source "${HOME}/wonder-aliases.sh"

export TERRAGRUNT_FETCH_DEPENDENCY_OUTPUT_FROM_STATE=true
export TERRAGRUNT_PROVIDER_CACHE=true
export TERRAGRUNT_STRICT_CONTROL=skip-dependencies-inputs
