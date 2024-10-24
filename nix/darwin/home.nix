{ pkgs, ... }: {
  imports = [
    ../common/git.nix
    ../common/neovim.nix
    ../common/zsh.nix
  ];

  home.packages = [
    pkgs.eza
  ];

  home.stateVersion = "24.05";
  programs.home-manager.enable = true;

  programs.neovim.cocLite.enable = true;
  programs.neovim.serverAliases = true;

  programs.zsh.powerlevel10k.enable = true;
  programs.zsh.initExtra = builtins.readFile ../../.extra-darwin.zsh;
}
