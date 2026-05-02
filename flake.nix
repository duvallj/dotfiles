{
  description = "System Flake";

  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    let
      inputs' = inputs // {
        # From https://lix.systems/add-to-config/#flake-based-configurations
        # Applies to both nix-darwin and nixos
        lix-module =
          { pkgs, ... }:
          {
            nixpkgs.overlays = [
              (final: prev: {
                inherit (final.lixPackageSets.stable)
                  nixpkgs-review
                  # nix-direnv # Broken, instructions need to be updated probably
                  nix-eval-jobs
                  nix-fast-build
                  colmena
                  ;
              })
            ];
            nix.package = pkgs.lixPackageSets.stable.lix;
          };
      };
      importSubmodule = path: import path inputs';
      submodules = [
        ./nix/hosts/hyper-v1
        ./nix/hosts/macbook-m4-pro
        ./nix/hosts/mammal
        ./nix/hosts/macbook-pro-2019
        ./nix/hosts/wsl
        ./nix/hosts/zephyrus
      ];
    in
    builtins.foldl' (inputs.nixpkgs.lib.recursiveUpdate) { } (builtins.map importSubmodule submodules);
}
