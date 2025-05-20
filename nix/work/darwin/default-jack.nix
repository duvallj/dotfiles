(import ../../darwin/mk-default.nix) {
  username = "jackduvall";
  hostname = "Jacks-MacBook-Pro";
  hostPlatform = "aarch64-darwin";
  nix-darwin-imports = [
    ../../common/default.nix
    ./work.nix
    {
      ids.gids.nixbld = 350;
    }
  ];
  home-manager-import = ./home.nix;
}
