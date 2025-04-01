{ ... }:
{
  imports = [
    ../../common/direnv.nix
    ../../common/git.nix
    ../../common/neovim.nix
    ../../common/zsh.nix
    ../../darwin/home.nix
    ./android.nix
    ./docker.nix
  ];

  programs.zsh.initExtra = builtins.readFile ../../../.extra-darwin-work.zsh;
}
