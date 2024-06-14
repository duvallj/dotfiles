{ pkgs, ... }:
{
  home.packages = with pkgs; [
    cmake
    clang
    nodejs_20
  ];
}
