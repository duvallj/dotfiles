{ lib, config, ... }:
{
  imports = [
    ./claude/default.nix
    ./direnv.nix
    ./docker.nix
    ./fonts.nix
    ./git.nix
    ./jujutsu.nix
    ./neovim.nix
    ./zsh.nix
  ];

  programs.claude.firejail.enable = lib.mkDefault false;
  programs.claude.sandbox.enable = lib.mkDefault false;
  programs.direnv.enable = lib.mkDefault true;
  programs.docker.nonManagedEnable = lib.mkDefault false;
  programs.git.nonManagedEnable = lib.mkDefault true;
  programs.jujutsu.nonManagedEnable = lib.mkDefault false;
  programs.neovim.nonManagedEnable = lib.mkDefault true;
  programs.zsh.enable = lib.mkDefault true;
  programs.zsh.powerlevel10k.enable = lib.mkDefault config.programs.zsh.enable;
  programs.zsh.kittyExtra.enable = lib.mkDefault config.programs.zsh.enable;

  fonts.fontconfig.enable = lib.mkDefault true;
}
