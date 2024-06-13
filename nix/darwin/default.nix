{ self, home-manager, lix-module, nix-darwin, ... }:
let
  configuration = { pkgs, ... }: {
    imports = [
      ../common/default.nix
      ./work.nix
    ];

    # Set Git commit hash for darwin-version.
    system.configurationRevision = self.rev or self.dirtyRev or null;

    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    system.stateVersion = 4;

    # The platform the configuration will be used on.
    nixpkgs.hostPlatform = "x86_64-darwin";

    users.users."jackduvall" = {
      name = "jackduvall";
      home = "/Users/jackduvall";
    };
  };
in
{
  # Build darwin flake using:
  # $ darwin-rebuild build --flake .#Seans-MacBook-Pro
  darwinConfigurations."Seans-MacBook-Pro" = nix-darwin.lib.darwinSystem {
    modules =
      [
        configuration
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users."jackduvall" = import ./home.nix;
        }
        lix-module.nixosModules.default
      ];
  };

  # Expose the package set, including overlays, for convenience.
  darwinPackages = self.darwinConfigurations."Seans-MacBook-Pro".pkgs;
}
