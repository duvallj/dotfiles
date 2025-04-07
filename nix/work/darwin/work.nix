{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    htop

    # For telescope-fzf-native
    cmake
    # Don't use clang, because that will mess up the global install we have thru xcode

    # For ~/wonder
    awscli2
    curlFull
    gnupg
    hivemind
    jq
    localstack
    nats-server
    pkg-config
    python310
    skeema
    sops
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
      "xcodesorg/made/xcodes"
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
      "xcodesorg/made"
    ];

    # Don't really care about idempotency for these. If I eventually do, will
    # move them into Nix packages instead.
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
    onActivation.cleanup = "zap";
  };
}
