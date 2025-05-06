{ ... }:
{
  imports = [
    ../../darwin/home.nix
    ./android.nix
    ./docker.nix
  ];

  programs.zsh.initExtra = builtins.readFile ../../../.extra-darwin-work.zsh;
}
