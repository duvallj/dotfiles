{ pkgs, ... }:
{
  home.packages = with pkgs; [
    cmake
    clang
    eza
    gnumake
    htop
    ninja
  ];
}
