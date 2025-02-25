{ pkgs, ... }:
{
  home.packages = with pkgs; [
    clang
    cmake
    htop
    nodejs_22
    pnpm_10
    usbutils
  ];
}
