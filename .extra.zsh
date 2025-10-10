alias ls="eza"
alias lf="eza --hyperlink"
alias rg="rg --hyperlink-format=default"

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

function extract {
  # Extract all filenames at the start of the line from the input stream
  sed -n 's/^\([a-zA-Z0-9_/.-]*\.[a-zA-Z0-9_/.-]*\).*$/\1/p' | sort -u
}

function pbim {
  # Extract all files from the 
  pbpaste | extract | xim
}

function conflicts {
  git conflicts | xim
}

function cam {
  git a && git cm $@
}
