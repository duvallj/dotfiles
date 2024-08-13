{
  description = "System Flake";

  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
  let
    importSubmodule = path: import path inputs;
    submodules = [
      ./nix/darwin/default.nix
      ./nix/nixos/default.nix
      ./nix/wsl/default.nix
    ];
  in
    builtins.foldl' (inputs.nixpkgs.lib.recursiveUpdate) {} (builtins.map importSubmodule submodules);
}
