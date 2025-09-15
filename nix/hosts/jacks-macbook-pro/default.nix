(import ../../modules/nix-darwin/mk-default.nix) {
  username = "jackduvall";
  hostname = "Jacks-MacBook-Pro";
  hostPlatform = "aarch64-darwin";
  nix-darwin-imports = [
    ../../modules/nix-darwin/work
    {
      ids.gids.nixbld = 350;
    }
  ];
  home-manager-import = ./home.nix;
}
