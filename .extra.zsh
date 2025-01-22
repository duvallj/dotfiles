alias ls="eza"

function replace {
  rg -l "$1" $3 | xargs sd "$1" "$2"
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
