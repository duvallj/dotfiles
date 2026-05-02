# Base system configuration for all platforms
{ pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    jq
    magic-wormhole
    nix-output-monitor
  ];

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  programs.zsh.enable = true;
  # Completions for system packages as well
  environment.pathsToLink = [ "/usr/share/zsh" ];

  # Allow some nonfree packages
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "claude-code"
    ];
}
