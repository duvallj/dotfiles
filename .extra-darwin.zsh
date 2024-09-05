alias ls="eza"
alias my="mysql -u root -h 127.0.0.1"

eval "$(brew shellenv)"
export PATH="$(brew --prefix)/opt/mysql-client@8.0/bin:${PATH}"

export WONDER_ROOT="${HOME}/wonder/src"
export CROAM_ENV="local"
source "${HOME}/wonder-aliases.sh"

source "$(brew --prefix)/opt/asdf/libexec/asdf.sh"
export PATH="${HOME}/.local/bin:$(go env GOPATH)/bin:${PATH}"

function replace {
  rg -l $3 "$1" | xargs sed -i '' "s/$1/$2/g"
}

function xim {
  $@ | xargs nvim -p
}

function fdim {
  xim fd $@
}

function rgim {
  xim rg -l $@
}

function conflicts {
  xim git conflicts
}

function cam {
  git a && git cm $@
}

function prune {
  header="${1:-jack}"
  git remote prune origin | sed -n -E "/${header}/ s/.*(${header}.*)/\\1/p" | xargs git branch -D
}

alias rbs="darwin-rebuild switch --flake \"${HOME}/dotfiles\""
