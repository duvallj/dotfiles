{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    htop

    # For telescope-fzf-native
    cmake
    # Don't use clang, because that will mess up the global install we have thru xcode

    # For ~/wonder
    curlFull
    gnupg
    nats-server
    pkg-config
    xcodes
  ];

  homebrew = {
    enable = true;
    brews = [
      "jenv"
      "mise"
      "swift-format"
      "swift-protobuf"

      "kafka"
      "mysql@8.0"
      "mysql-client@8.0"
      "redis"

      "aria2"
    ];
    casks = [
      "keybase"
      "ngrok"
      {
        name = "tunnelblick";
        args = {
          appdir = "/Applications";
          require_sha = true;
        };
      }
    ];
    taps = [
      "homebrew/services"
    ];

    # Don't really care about idempotency for these. If I eventually do, will
    # move them into Nix packages instead.
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
    onActivation.cleanup = "zap";
  };
}
