{ ... }:
{
  imports = [
    ../../modules/home-manager
    ../../modules/home-manager/work
  ];

  home.stateVersion = "24.05";
  programs.home-manager.enable = true;

  xdg.enable = true;

  programs.jujutsu.nonManagedEnable = true;
}
