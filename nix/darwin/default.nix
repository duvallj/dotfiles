(import ./mk-default.nix) {
  username = "jackduvall";
  hostname = "Jacks-Mac-mini";
  hostPlatform = "x86_64-darwin";
  nix-darwin-imports = [
    ../common/default.nix
  ];
  home-manager-import = ./home.nix;
}
