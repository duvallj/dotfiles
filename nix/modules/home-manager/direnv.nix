{ lib, config, ... }:
let
  cfg = config.programs.direnv;
in
{
  config = lib.mkIf cfg.enable {
    programs = {
      direnv = {
        enableZshIntegration = true;
        nix-direnv.enable = true;
      };
    };
  };
}
