(import ../../modules/nix-darwin/mk-default.nix) {
  username = "jackduvall";
  hostname = "Jacks-Mac-mini";
  hostPlatform = "x86_64-darwin";
  nix-darwin-imports = [
    ../../modules/nixos/common
    {
      ids.gids.nixbld = 350;
    }
  ];
  home-manager-import = ./home.nix;
}
