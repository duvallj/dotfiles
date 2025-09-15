{ ... }:
{
  imports = [
    ../common/direnv.nix
    ../common/git.nix
    ../common/neovim.nix
    ../common/zsh.nix
    ./packages.nix
  ];

  home.stateVersion = "23.11";
  programs.home-manager.enable = true;

  programs.neovim.serverAliases = true;

  programs.zsh.powerlevel10k.enable = true;
  programs.zsh.initContent = builtins.readFile ../../.extra-nixos.zsh;
}
