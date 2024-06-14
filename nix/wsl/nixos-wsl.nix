let
  nixos-wsl = builtins.fetchTarball {
    url = "https://github.com/nix-community/NixOS-WSL/archive/refs/tags/2311.5.3.tar.gz";
    sha256 = "sha256:0ms9rf9g5l4736dwhg4pfn0yvh6mimvwbl6d9yzh8jqca7asidsa";
  };
in
  import "${nixos-wsl}/modules"
