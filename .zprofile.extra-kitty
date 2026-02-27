if [[ ! -v KITTY_TAB_ID ]] && (( $+commands[kitten] )) then
  # If not already calculated, define KITTY_TAB_ID from our built-in KITTY_WINDOW_ID
  export KITTY_TAB_ID="$(kitten @ ls --match "id:${KITTY_WINDOW_ID}" 2> /dev/null | jq '.[0].tabs[0].id')"
fi
