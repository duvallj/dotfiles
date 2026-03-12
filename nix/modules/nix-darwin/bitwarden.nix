{
  config,
  lib,
  ...
}:
let
  cfg = config.bitwarden;
in
{
  options.bitwarden = {
    enable = lib.mkEnableOption "Whether to enable the Bitwarden desktop client";
  };

  config = lib.mkIf cfg.enable {
    # Assume you have homebrew configured elsewhere
    homebrew = {
      casks = [
        {
          name = "bitwarden";
          args = {
            appdir = "/Applications";
            require_sha = true;
          };
        }
      ];
    };

    # assumes you have "start at login" and "enable SSH agent" enabled in the settings
    environment.variables = {
      SSH_AUTH_SOCK = "$HOME/.bitwarden-ssh-agent.sock";
    };

  };
}
