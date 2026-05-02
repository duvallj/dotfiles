(import ../../modules/nix-darwin/mk-default.nix) {
  username = "duvall";
  hostname = "Seans-MacBook-Pro";
  hostPlatform = "x86_64-darwin";
  configuration =
    { ... }:
    {
      imports = [
        ../../modules/nix-darwin/work
      ];
    };
  home-manager-import = ../macbook-m4-pro/home.nix;
}
