{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.fonts;
in
{
  options.fonts = {
    installPatchedFonts = lib.mkOption {
      default = cfg.fontconfig.enable;
      example = true;
      description = "Whether to install extra nerd-fonts packages";
      type = lib.types.bool;
    };
  };

  config = lib.mkIf cfg.installPatchedFonts {
    home.packages = with pkgs; [
      nerd-fonts.jetbrains-mono
    ];
  };
}
