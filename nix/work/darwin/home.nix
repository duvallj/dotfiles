{ ... }:
{
  imports = [
    ../../darwin/home.nix
    ./android.nix
    ./docker.nix
  ];

  programs.zsh.initContent = builtins.readFile ../../../.extra-darwin-work.zsh;
}
