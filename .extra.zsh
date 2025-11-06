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

function replace {
  rg -l "$1" $3 | xargs sd "$1" "$2"
}

function nvim {
  if command -v kitten &> /dev/null; then
    # If running in Kitty, get the tab id for a remote Neovim instance
    tab_id="$(kitten @ ls --match "id:${KITTY_WINDOW_ID}" | jq '.[0].tabs[0].id')"
    pipe="${XDG_CACHE_HOME:-${HOME}/.cache}/nvim/server-${tab_id}.pipe"
    if [ -S "${pipe}" ]; then
      if [ "$1" = "-k" ] || [ "$1" = "--kitty-remote" ]; then
        # Run command in existing instance
        shift
        command nvim --server "${pipe}" --remote-tab "$@"
      else
        # Launch new, non-remote instance
        command nvim "$@"
      fi
    else
      # Launch instance if there isn't one already
      if [ "$1" = "-k" ] || [ "$1" = "--kitty-remote" ]; then
        shift
      fi
      command nvim --listen "${pipe}" "$@"
    fi
  else
    command nvim "$@"
  fi
}

function xim {
  xargs nvim -p "$@"
}

function fdim {
  fd "$@" | xim
}

function rgim {
  # List all files with that search, and also search for that pattern within nvim
  # Assumes the pattern is the first argument
  rg -l "$@" | xim "+/$1"
}

function extract {
  # Extract all filenames at the start of the line from the input stream
  sed -n 's/^\([a-zA-Z0-9_/.-]*\.[a-zA-Z0-9_/.-]*\).*$/\1/p' | sort -u
}

function pbim {
  # Extract all files from the 
  pbpaste | extract | xim "$@"
}

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
