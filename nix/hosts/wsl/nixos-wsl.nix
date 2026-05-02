let
  nixos-wsl = builtins.fetchTarball {
    url = "https://github.com/nix-community/NixOS-WSL/archive/dee4425dcee3149475ead0cb6a616b8a028c5888.tar.gz";
    sha256 = "sha256:1gfaibh7yhpisd2vxw7vawhgzy51l9yc28n1apmbh1cqg0g8dnib";
  };
in
import "${nixos-wsl}/modules"
