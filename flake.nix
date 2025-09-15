{
  description = "System Flake";

  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.93.2-1.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    let
      importSubmodule = path: import path inputs;
      submodules = [
        ./nix/hosts/hyper-v1
        ./nix/hosts/jacks-macbook-pro
        ./nix/hosts/mac-mini
        ./nix/hosts/seans-macbook-pro
        ./nix/hosts/wsl
        ./nix/hosts/zephyrus
      ];
    in
    builtins.foldl' (inputs.nixpkgs.lib.recursiveUpdate) { } (builtins.map importSubmodule submodules);
}
