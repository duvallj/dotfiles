let
  nixos-wsl = builtins.fetchTarball {
    url = "https://github.com/nix-community/NixOS-WSL/archive/refs/tags/2405.5.4.tar.gz";
    sha256 = "sha256:1hj3lbrykzqp88wvxv86b8lm41dyqhid71vhms1g89svx54nrcj6";
  };
in
  import "${nixos-wsl}/modules"
