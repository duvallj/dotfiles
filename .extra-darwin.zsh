alias ls="eza"
alias rg="command rg --hidden"
alias my="mysql -u root -h 127.0.0.1"

eval "$(/usr/local/bin/brew shellenv)"
export PATH="/usr/local/opt/mysql-client/bin:${PATH}"

export WONDER_ROOT="${HOME}/wonder/src"
export CROAM_ENV="local"
source "${HOME}/wonder-aliases.sh"

. /usr/local/opt/asdf/libexec/asdf.sh
localbin="${HOME}/.local/bin"
export GOBIN="${localbin}/go"
export PATH="${localbin}:${GOBIN}:${PATH}"

export DOTFILES_ENABLE_COC_NVIM=1

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

alias drs="darwin-rebuild switch --flake \"${HOME}/dotfiles\""
