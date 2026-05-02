{ lib, config, ... }:
{
  imports = [
    ./claude
    ./direnv.nix
    ./docker.nix
    ./fonts.nix
    ./git.nix
    ./jujutsu.nix
    ./neovim.nix
    ./zsh.nix
  ];

  programs.direnv.enable = lib.mkDefault true;
  programs.git.nonManagedEnable = lib.mkDefault true;
  programs.neovim.nonManagedEnable = lib.mkDefault true;
  programs.zsh.enable = lib.mkDefault true;
  programs.zsh.powerlevel10k.enable = lib.mkDefault config.programs.zsh.enable;
  programs.zsh.kittyExtra.enable = lib.mkDefault config.programs.zsh.enable;

  fonts.fontconfig.enable = lib.mkDefault true;
}
