{ ... }:
{
  imports = [
    ../../darwin/docker.nix
    ../../darwin/home.nix
    ./android.nix
  ];

  programs.zsh.initContent = builtins.readFile ../../../.extra-darwin-work.zsh;
}
