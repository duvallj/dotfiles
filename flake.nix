{
  description = "System Flake";

  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.92.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nix-darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    let
      importSubmodule = path: import path inputs;
      submodules = [
        ./nix/darwin/default.nix
        ./nix/work/darwin/default-jack.nix
        ./nix/work/darwin/default-sean.nix
        ./nix/nixos/default.nix
        ./nix/wsl/default.nix
      ];
    in
    builtins.foldl' (inputs.nixpkgs.lib.recursiveUpdate) { } (builtins.map importSubmodule submodules);
}
