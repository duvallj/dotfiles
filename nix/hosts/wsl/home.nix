{ ... }:
{
  imports = [
    ../nixos/home.nix
    ./packages.nix
  ];

  home.sessionVariables = {
    DOTFILES_WSL = 1;
  };

  programs.zsh.initContent = builtins.readFile ../../.extra-wsl.zsh;
}
