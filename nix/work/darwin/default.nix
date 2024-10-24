(import ../../darwin/mk-default.nix) {
  username = "jackduvall";
  hostname = "Seans-Macbook-Pro";
  nix-darwin-imports = [
    ../../common/default.nix
    ./work.nix
  ];
  home-manager-import = ./home.nix;
}
