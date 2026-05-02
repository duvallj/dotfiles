{ lib, config, ... }:
let
  cfg = config.programs.docker;
in
{
  options.programs.docker = {
    nonManagedEnable = lib.mkEnableOption "Whether to enable my custom non-managed install of docker.";
  };
  config = lib.mkIf cfg.nonManagedEnable {
    # initExtraBeforeCompInit
    programs.zsh.initContent = lib.mkOrder 550 ''
      # To enable these completions: run `mkdir -p ~/.docker/completions && docker completion zsh > ~/.docker/completions/_docker`
      FPATH="$HOME/.docker/completions:$FPATH"
    '';

    # TODO: may eventually want to look at colima as an alternative, since Docker Desktop is always smelly (impure)
  };
}
