{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    htop
    uv

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
      "docker-compose"
      "mise"
      "mysql-client@8.0"
      "mysql@8.0"
      "poppler"
      "swift-format"
      "swift-protobuf"

      "aria2"
      "libopusenc"
      "libvpx"
    ];
    casks =
      builtins.map
        (app: {
          name = app;
          args = {
            appdir = "/Applications";
            require_sha = true;
          };
        })
        [
          "keybase"
          "kitty"
          "ngrok"
          "docker-desktop"
          "tunnelblick"
        ];

    # Don't really care about idempotency for these. If I eventually do, will
    # move them into Nix packages instead.
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
    onActivation.cleanup = "zap";
  };
}
