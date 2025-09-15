{
  username,
  hostname,
  hostPlatform,
  nix-darwin-imports,
  home-manager-import,
}:
{
  self,
  home-manager,
  lix-module,
  nix-darwin,
  ...
}:
let
  configuration =
    { ... }:
    {
      imports = nix-darwin-imports;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 4;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = hostPlatform;

      users.users.${username} = {
        name = username;
        home = "/Users/${username}";
      };

      system.primaryUser = username;
    };
in
{
  darwinConfigurations.${hostname} = nix-darwin.lib.darwinSystem {
    modules = [
      configuration
      home-manager.darwinModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.${username} = import home-manager-import;
      }
      lix-module.nixosModules.default
    ];
  };

  # Expose the package set, including overlays, for convenience.
  darwinPackages = self.darwinConfigurations.${hostname}.pkgs;
}
