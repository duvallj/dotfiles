{ lib, config, ... }:
let
  cfg = config.programs.fzf;
in
{
  config = lib.mkIf cfg.enable {
    programs.fzf = {
      enableZshIntegration = lib.mkDefault true;
    };
  };
}
