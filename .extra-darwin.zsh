alias ls="eza"

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
