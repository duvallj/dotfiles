(import ../../modules/nix-darwin/mk-default.nix) {
  username = "jackduvall";
  hostname = "Seans-MacBook-Pro";
  hostPlatform = "x86_64-darwin";
  configuration =
    { ... }:
    {
      imports = [
        ../../modules/nix-darwin/work
      ];
    };
  home-manager-import = ../jacks-macbook-pro/home.nix;
}
