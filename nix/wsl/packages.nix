{ pkgs, ... }:
{
  home.packages = with pkgs; [
    clang
    cmake
    htop
    nodejs_20
    usbutils
  ];
}
