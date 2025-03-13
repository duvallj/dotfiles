{ pkgs, ... }:
{
  home.packages = with pkgs; [
    age
    clang
    cmake
    htop
    nodejs_22
    pnpm_10
    sops
    usbutils
  ];
}
