alias rg="command rg --hyperlink-format=default"
alias fd="command fd --hyperlink=auto"
# TODO: use --hyperlink=auto once it supports that
function ls {
  if [ -t 1 ]; then
    command eza --hyperlink "$@"
  else
    command eza "$@"
  fi
}

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."

function replace {
  rg -l "$1" $3 | xargs sd "$1" "$2"
}

function xim {
  extra_args="-p"
  if [[ "$1" == "-k" ]]; then
    shift
    extra_args="-k"
  fi
  xargs nvim ${extra_args} "$@"
}
alias xkm="xim -k"

function fdim {
  extra_args=""
  if [[ "$1" == "-k" ]]; then
    shift
    extra_args="-k"
  fi
  fd "$@" | xim ${extra_args}
}
alias fdkm="fdim -k"

function rgim {
  extra_args=""
  if [[ "$1" == "-k" ]]; then
    shift
    extra_args="-k"
  fi
  # List all files with that search, and also search for that pattern within nvim
  # Assumes the pattern is the first argument
  rg -l "$@" | xim ${extra_args} "+/$1"
}
alias rgkm="rgim -k"

function extract {
  # Extract all filenames at the start of the line from the input stream
  sed -n 's/^\([a-zA-Z0-9_/.-]*\.[a-zA-Z0-9_/.-]*\).*$/\1/p' | sort -u
}

function pbim {
  # Extract all files from the 
  pbpaste | extract | xim "$@"
}
alias pbkm="pbim -k"

function conflicts {
  git conflicts | xim "$@"
}

function unstaged {
  git diff --name-only | xim "$@"
}

function staged {
  git diff --name-only --staged | xim "$@"
}

function cam {
  git a && git cm "$@"
}
