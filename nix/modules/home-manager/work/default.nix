{ lib, ... }:
{
  imports = [
    ./android.nix
  ];

  programs.zsh.initContent = lib.mkMerge [
    (builtins.readFile ../../../../.extra-darwin.zsh)
    (builtins.readFile ../../../../.extra-darwin-work.zsh)
  ];
}
