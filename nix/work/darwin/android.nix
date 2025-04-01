{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    sdkmanager
  ];

  home.sessionVariables = {
    ANDROID_HOME = "${config.home.homeDirectory}/wonder/.android-sdk";
  };
}
