{ pkgs, ... }:
{
  home.packages = with pkgs; [
    cmake
    clang
    htop
    nodejs_20
    usbutils
  ];
}
