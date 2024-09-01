{ ... }:
{
  imports = [
    ../nixos/home.nix
    ./packages.nix
  ];

  programs.zsh.initExtra = builtins.readFile ../../.extra-wsl.zsh;
}
