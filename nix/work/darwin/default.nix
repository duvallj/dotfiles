(import ../../darwin/mk-default.nix) {
  username = "jackduvall";
  hostname = "Seans-MacBook-Pro";
  nix-darwin-imports = [
    ../../common/default.nix
    ./work.nix
  ];
  home-manager-import = ./home.nix;
}
