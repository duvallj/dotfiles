{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.programs.claude;
in
{
  options.programs.claude = {
    firejail.enable = lib.mkEnableOption "Whether to add the 'claude-yolo' firejail script";
    sandbox.enable = lib.mkEnableOption "Whether to add the 'claude-sandbox' sandbox-exec script";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.firejail.enable {
      home.packages = [ (pkgs.callPackage ./claude-firejail.nix { }) ];
    })
    (lib.mkIf cfg.sandbox.enable {
      home.packages = [
        pkgs.claude-code
        (pkgs.callPackage ./claude-sandbox.nix { })
      ];
    })
  ];
}
