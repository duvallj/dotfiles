{ ... }:
{
  imports = [
    ../../modules/home-manager
    ./packages.nix
  ];

  home.stateVersion = "23.11";
  programs.home-manager.enable = true;

  programs.neovim.serverAliases = true;

  programs.zsh.kittyExtra.enable = false;
  programs.zsh.initContent = builtins.readFile ../../../.zshrc.extra-hyper-v1;

  fonts.fontconfig.enable = false;
}
