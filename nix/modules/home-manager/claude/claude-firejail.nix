{
  pkgs,
  firejail,
  ...
}:
pkgs.writeShellScriptBin "claude-yolo" ''
  set -e

  CANDIDATE_PATHS_RW=(
    "''${PWD}"
    "''${HOME}/.claude"
    "''${HOME}/.claude.json"
    "''${HOME}/.config/claude"
    "''${HOME}/.cache"
  )

  CANDIDATE_PATHS_RO=(
    "''${HOME}/.config/git"
    /nix/store
    /nix/var
  )

  WHITELIST_ARGS=()
  for path in "''${CANDIDATE_PATHS_RW[@]}"; do
    if [[ -e "$path" ]]; then
      WHITELIST_ARGS+=(--whitelist="$path")
    fi
  done
  for path in "''${CANDIDATE_PATHS_RO[@]}"; do
    if [[ -e "$path" ]]; then
      WHITELIST_ARGS+=(--whitelist="$path")
      WHITELIST_ARGS+=(--read-only="$path")
    fi
  done

  set -x

  ${firejail} --noprofile "''${WHITELIST_ARGS[@]}" claude --permission-mode bypassPermissions "$@"
''
