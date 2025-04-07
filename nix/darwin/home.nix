{ ... }:
{
  imports = [
    ../common/git.nix
    ../common/kitty.nix
    ../common/neovim.nix
    ../common/zsh.nix
  ];

  home.stateVersion = "24.05";
  programs.home-manager.enable = true;

  kitty.enable = true;

  programs.neovim.serverAliases = true;

  programs.zsh.powerlevel10k.enable = true;
  programs.zsh.initExtra = builtins.readFile ../../.extra-darwin.zsh;
}
