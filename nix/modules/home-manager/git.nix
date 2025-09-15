{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.programs.git;
in
{
  options.programs.git = {
    nonManagedEnable = lib.mkEnableOption "Whether to enable my custom non-managed version of git";
  };
  config = lib.mkIf cfg.nonManagedEnable {
    # Configuration handled by setup.sh
    home.packages = with pkgs; [
      difftastic
      git
      git-lfs
    ];
  };
}
