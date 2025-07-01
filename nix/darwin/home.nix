{ ... }:
{
  imports = [
    ../common/direnv.nix
    ../common/git.nix
    ../common/neovim.nix
    ../common/zsh.nix
  ];

  home.stateVersion = "24.05";
  programs.home-manager.enable = true;

  programs.neovim.serverAliases = true;

  programs.zsh.powerlevel10k.enable = true;
  programs.zsh.initContent = builtins.readFile ../../.extra-darwin.zsh;
}
