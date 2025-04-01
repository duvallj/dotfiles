(import ../../darwin/mk-default.nix) {
  username = "jackduvall";
  hostname = "Seans-MacBook-Pro";
  hostPlatform = "x86_64-darwin";
  nix-darwin-imports = [
    ../../common/default.nix
    ./work.nix
  ];
  home-manager-import = ./home.nix;
}
