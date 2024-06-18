{ pkgs, ... }:
{
  home.packages = with pkgs; [
    difftastic
    git
    git-lfs
  ];
  # Use direct symlink instead of programs.git.enable since we don't need any
  # special Nix options, .gitconfig on its own is enough.
  home.file.".gitconfig".source = ../../.gitconfig;
}
