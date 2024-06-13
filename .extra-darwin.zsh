alias ls="eza"
alias my="mysql -u root -h 127.0.0.1"
alias prune="git remote prune origin | sed -n -E '/jack/ s/.*(jack.*)/\1/p' | xargs git branch -D"

eval "$(/usr/local/bin/brew shellenv)"
export PATH="/usr/local/opt/mysql-client/bin:$PATH"

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

function fdim {
  fd $@ | xargs nvim -p
}

function rgim {
  rg -l $@ | xargs nvim -p
}

alias drs="darwin-rebuild switch --flake ~/dotfiles"
