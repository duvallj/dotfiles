# Nix module for a flakes-enabled NixOS install
{
  self,
  home-manager,
  lix-module,
  nixpkgs,
  ...
}:
let
  username = "me";
  hostname = "nixos";

  configuration =
    { ... }:
    {
      imports = [
        ./configuration.nix
        ../common/default.nix
      ];

      users.users.${username} = {
        isNormalUser = true;
        extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
      };
    };
in
{
  nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      configuration
      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.backupFileExtension = "backup";
        home-manager.users.${username} = import ./home.nix;
      }
      lix-module.nixosModules.default
    ];
  };
}
