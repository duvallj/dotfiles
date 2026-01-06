{
  pkgs,
  ...
}:
pkgs.stdenv.mkDerivation {
  pname = "claude-sandbox";
  version = "0.2.0";

  src = ./.;

  buildInputs = [ pkgs.bash ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    bin_install_file="$out/bin/$NIX_MAIN_PROGRAM"
    cat > $bin_install_file <<EOF
    #!/usr/bin/env bash

    NIX_NOREAD_SB="$out/noread.sb"
    EOF
    # append claude-sandbox script without the hashbang
    tail -n +2 claude-sandbox >> "$bin_install_file"
    chmod +x "$bin_install_file"

    runHook postInstall
  '';

  meta = with pkgs.lib; {
    description = "A macOS sandbox configuration for Claude Code";
    longDescription = ''
      A macOS sandbox-exec profile that limits Claude Code's access to your
      filesystem. It prevents Claude Code from reading your home directory
      (except for the current working directory) and restricts writes to
      only the target directory and temporary locations.
    '';
    license = licenses.mit;
    platforms = platforms.darwin;
    mainProgram = "claude-sandbox";
  };
}
