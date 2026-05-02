{ lib, ... }:
{
  imports = [
    ./android.nix
  ];

  programs.zsh.profileExtra = builtins.readFile ../../../../.zprofile.extra-darwin-work;
  programs.zsh.initContent = lib.mkMerge [
    (builtins.readFile ../../../../.zshrc.extra-darwin)
    (builtins.readFile ../../../../.zshrc.extra-darwin-work)
  ];
}
