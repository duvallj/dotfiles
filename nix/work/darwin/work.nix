{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # For ~/wonder
    awscli2
    curlFull
    gnupg
    hivemind
    jq
    nats-server
    pkg-config
    skeema

    # For ~/node-webrtc
    cmake
    htop
    ninja
  ];

  homebrew = {
    enable = true;
    brews = [
      "asdf"
      "jenv"
      "swift-format"
      "swift-protobuf"

      "consul"
      "kafka"
      "mysql@8.0"
      "mysql-client@8.0"
      "redis"

      "xcodesorg/made/xcodes"
    ];
    casks = [
      "keybase"
      "ngrok"
      {
        name = "tunnelblick";
        args = { appdir = "/Applications"; require_sha = true; };
      }
    ];
    taps = [
      "homebrew/services"
      "xcodesorg/made"
    ];

    # Don't really care about idempotency for these. If I eventually do, will
    # move them into Nix packages instead.
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
    onActivation.cleanup = "zap";
  };
}
