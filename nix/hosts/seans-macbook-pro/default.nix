(import ../../modules/nix-darwin/mk-default.nix) {
  username = "jackduvall";
  hostname = "Seans-MacBook-Pro";
  hostPlatform = "x86_64-darwin";
  nix-darwin-imports = [
    ../../modules/nix-darwin/work
  ];
  home-manager-import = ./home.nix;
}
