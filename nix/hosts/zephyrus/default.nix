# We only have home-manager since this is a debian install
{ nixpkgs, home-manager, ... }:
{
  homeConfigurations."Zephyrus" = home-manager.lib.homeManagerConfiguration {
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
    modules = [ ./home.nix ];
  };
}
