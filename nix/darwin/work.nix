{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    cmake
    htop
    ninja
  ];

  homebrew = {
    enable = true;
    brews = [
      "asdf"
      "coreutils"
      "curl"
      # Taken care of by ../common/git.nix
      # "git"
      # "git-lfs"
      "gpg"
      "hivemind"
      "jenv"
      "jq"
      "pkg-config"
      "skeema/tap/skeema"
      "swift-format"
      "swift-protobuf"

      # For services. TODO: split these out into something separate ?
      "consul"
      "kafka"
      "mysql"
      "mysql-client"
      "redis"
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
      "skeema/tap"
    ];

    # Don't really care about idempotency for these. If I eventually do, will
    # move them into Nix packages instead.
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
    onActivation.cleanup = "zap";
  };
}
