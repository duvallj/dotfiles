{ lib, ... }:
{
  # initExtraBeforeCompInit
  programs.zsh.initContent = lib.mkOrder 550 ''
    # To enable these completions: run `mkdir -p ~/.docker/completions && docker completion zsh > ~/.docker/completions/_docker`
    FPATH="$HOME/.docker/completions:$FPATH"
  '';

  # TODO: may eventually want to look at colima as an alternative, since Docker Desktop is always smelly (impure)
}
