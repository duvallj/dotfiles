{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.programs.jujutsu;
in
{
  options.programs.jujutsu = {
    nonManagedEnable = lib.mkEnableOption "Whether to enable a non-managed install of jujutsu (jj)";
  };

  config = lib.mkIf cfg.nonManagedEnable {
    programs.git.nonManagedEnable = true;
    home.packages = with pkgs; [
      jujutsu
    ];
  };
}
