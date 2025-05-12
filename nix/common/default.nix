# Base system configuration for all platforms
{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    eza
    fd
    jq
    magic-wormhole
    nix-output-monitor
    ripgrep
    sd
  ];

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  programs.zsh.enable = true;
  # Completions for system packages as well
  environment.pathsToLink = [ "/usr/share/zsh" ];
}
