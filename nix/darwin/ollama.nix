{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.ollama;
in
{
  options.ollama = {
    enable = lib.mkEnableOption (lib.mdDoc "ollama");
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.ollama;
      defaultText = lib.literalExpression "pkgs.ollama";
      description = lib.mdDoc "The package to use for ollama";
    };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    launchd.user.agents.ollama = {
      script = ''
        exec ${cfg.package}/bin/ollama serve
      '';
      serviceConfig = {
        KeepAlive = true;
        RunAtLoad = true;
        StandardOutPath = "/tmp/ollama.out.log";
        StandardErrorPath = "/tmp/ollama.err.log";
      };
    };
  };
}
