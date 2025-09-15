{
  self,
  home-manager,
  lix-module,
  nixpkgs,
  ...
}:
let
  username = "nixos";
  hostname = "nixos-wsl";

  configuration =
    { pkgs, ... }:
    {
      imports = [
        (import ./nixos-wsl.nix)
      ];

      wsl.enable = true;
      wsl.defaultUser = username;
      networking.hostName = hostname;

      wsl.wslConf = {
        interop.enabled = true;
        interop.appendWindowsPath = false;
      };
      wsl.usbip.enable = true;

      # This value determines the NixOS release from which the default
      # settings for stateful data, like file locations and database versions
      # on your system were taken. It's perfectly fine and recommended to leave
      # this value at the release version of the first install of this system.
      # Before changing this value read the documentation for this option
      # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
      system.stateVersion = "23.11"; # Did you read the comment?

      programs.zsh.enable = true;
      users.defaultUserShell = pkgs.zsh;

      virtualisation.docker.enable = true;
      users.users.${username}.extraGroups = [ "docker" ];
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
        home-manager.users.${username} = (import ./home.nix);
      }
      lix-module.nixosModules.default
    ];
  };
}
