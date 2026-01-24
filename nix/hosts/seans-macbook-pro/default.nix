(import ../../modules/nix-darwin/mk-default.nix) {
  username = "jackduvall";
  hostname = "Seans-MacBook-Pro";
  hostPlatform = "x86_64-darwin";
  nix-darwin-imports = [
    ../../modules/nix-darwin/work
    ../../modules/nixos/common
  ];
  home-manager-import = ../jacks-macbook-pro/home.nix;
}
