{ pkgs, ... }:
{
  home.packages = with pkgs; [
    difftastic
    git
    git-lfs
  ];
  # Configuration handled by setup.sh
}
