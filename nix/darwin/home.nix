{ pkgs, ... }: {
  imports = [
    ./neovim.nix
  ];

  home.stateVersion = "24.05";
  programs.home-manager.enable = true;
}