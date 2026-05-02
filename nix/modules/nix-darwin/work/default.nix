{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # System utilities
    htop
    uv

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
      # Programs that I want to stay up-to-date
      "gh"

      # Required for ~/wonder, also need to be global because of that
      "docker-compose"
      "mise"
      "mysql-client@8.0"
      "mysql@8.0"
      "poppler"
      "swift-format"

      # Libraries for ~/wonder, also need to be global because of that
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
          # Programs that I want to stay up-to-date
          "claude-code"
          "kitty"
          "secretive"

          # Required for ~/wonder
          "docker-desktop"
          "keybase"
          "ngrok"
          "tunnelblick"
        ];

    # Don't really care about idempotency for these. If I eventually do, will
    # move them into Nix packages instead.
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
    onActivation.cleanup = "zap";
  };
}
