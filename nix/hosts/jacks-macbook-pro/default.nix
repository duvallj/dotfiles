(import ../../modules/nix-darwin/mk-default.nix) {
  username = "jackduvall";
  hostname = "Jacks-MacBook-Pro";
  hostPlatform = "aarch64-darwin";
  configuration = ./nix-darwin.nix;
  home-manager-import = ./home.nix;
}
