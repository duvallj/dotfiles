(import ../../modules/nix-darwin/mk-default.nix) {
  username = "jackduvall";
  hostname = "Jacks-Mac-mini";
  hostPlatform = "x86_64-darwin";
  nix-darwin-imports = [ ];
  home-manager-import = ./home.nix;
}
