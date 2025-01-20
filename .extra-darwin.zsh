function prune {
  header="${1:-jack}"
  git remote prune origin | sed -n -E "/${header}/ s/.*(${header}.*)/\\1/p" | xargs git branch -D
}

alias rbs="darwin-rebuild switch --flake \"${HOME}/dotfiles\""
