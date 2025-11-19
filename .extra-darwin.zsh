function prune {
  header="${1:-jack}"
  git branch --list | rg -v "^[*+]|${header}" | xargs git branch -D
  git remote prune origin | sed -n -E "/${header}/ s/.*(${header}.*)/\\1/p" | xargs git branch -D
}

alias rbs="sudo darwin-rebuild switch --flake \"${HOME}/dotfiles\""
