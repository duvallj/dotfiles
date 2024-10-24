(import ./mk-default.nix) {
  username = "jackduvall";
  hostname = "Jacks-Mac-mini";
  nix-darwin-imports = [
    ../common/default.nix
  ];
  home-manager-import = ./home.nix;
}
