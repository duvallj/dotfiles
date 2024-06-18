{ pkgs, ... }: {
  imports = [
    ../common/git.nix
    ../common/neovim.nix
    ../common/zsh.nix
  ];

  # For options in .extra-darwin.zsh
  home.packages = [
    pkgs.eza
  ];

  home.stateVersion = "24.05";
  programs.home-manager.enable = true;

  programs.zsh.powerlevel10k.enable = true;
  programs.zsh.initExtra = builtins.readFile ../../.extra-darwin.zsh;
}
