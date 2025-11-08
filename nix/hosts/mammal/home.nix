{ pkgs, ... }:
{
  imports = [
    ../../modules/home-manager
  ];

  home.username = "me";
  home.homeDirectory = "/home/me";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  programs.jujutsu.nonManagedEnable = true;
  programs.zsh.initContent = builtins.readFile ../../../.extra-mammal.zsh;
  # I don't plan on doing a lot of editing from this machine really, so don't need this
  programs.zsh.kittyExtra.enable = false;

  home.packages = with pkgs; [
  ];
}
