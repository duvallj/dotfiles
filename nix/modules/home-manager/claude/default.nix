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
    sandbox.nonManaged = lib.mkOption {
      default = false;
      description = "Whether to use the version of noread.sb not managed by nix, for quicker iteration.";
      type = lib.types.bool;
    };
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
    (lib.mkIf cfg.sandbox.nonManaged {
      home.sessionVariables = {
        # TODO: make "dotfiles directory" more integrated into nix
        NOREAD_SB = "${config.home.homeDirectory}/dotfiles/nix/modules/home-manager/claude/noread.sb";
      };
    })
  ];
}
