{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.programs.direnv;
in
{
  config = lib.mkIf cfg.enable {
    programs.direnv = {
      package = pkgs.lixPackageSets.stable.nix-direnv;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
  };
}
