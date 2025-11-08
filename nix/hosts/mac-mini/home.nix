{ pkgs, ... }:
{
  imports = [
    ../../modules/home-manager
  ];

  home.packages = with pkgs; [
    htop
  ];

  home.stateVersion = "24.05";
  programs.home-manager.enable = true;

  programs.zsh.powerlevel10k.enable = true;
  programs.zsh.initContent = builtins.readFile ../../../.extra-darwin.zsh;

  xdg.enable = true;
}
