{ pkgs, ... }:
{
  home.packages = with pkgs; [
    clang
    cmake
    corepack
    htop
    nodejs_22
    usbutils
  ];
}
