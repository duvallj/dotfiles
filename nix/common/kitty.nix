{
  config,
  lib,
  ...
}:
let
  cfg = config.kitty;
in
{
  options.kitty = {
    enable = lib.mkEnableOption "Whether to install a Kitty configuration using Home Manager";
  };
  config = lib.mkIf cfg.enable {
    home.file = {
      "kitty-config" = {
        source = ../../kitty;
        target = ".config/kitty";
        recursive = true;
      };
    };
  };
}
