{ ... }:
{
  imports = [
    ../../modules/nix-darwin/work
  ];

  ids.gids.nixbld = 350;

  bitwarden.enable = true;
}
