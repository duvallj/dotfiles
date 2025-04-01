alias ls="eza"

function replace {
  rg -l "$1" $3 | xargs sd "$1" "$2"
}

function xim {
  xargs nvim -p $@
}

function fdim {
  fd $@ | xim
}

function rgim {
  # List all files with that search, and also search for that pattern within nvim
  # Assumes the pattern is the first argument
  rg -l $@ | xim "+/$1"
}

function conflicts {
  git conflicts | xim
}

function cam {
  git a && git cm $@
}
