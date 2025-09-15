{ pkgs, ... }:
{
  home.packages = with pkgs; [
    cmake
    clang
    gnumake
    htop
    ninja
  ];
}
