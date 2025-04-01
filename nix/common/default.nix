# Base system configuration for all platforms
{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    eza
    fd
    jq
    magic-wormhole
    ripgrep
    sd
  ];

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Necessary for using the Lix binary cache
  nix.settings.substituters = [
    "https://cache.lix.systems"
  ];

  nix.settings.trusted-public-keys = [
    "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
  ];

  programs.zsh.enable = true;
  # Completions for system packages as well
  environment.pathsToLink = [ "/usr/share/zsh" ];
}
