{
  pkgs,
  ...
}:
pkgs.stdenv.mkDerivation {
  pname = "claude-sandbox";
  version = "0.1.0";

  src = ./.;

  buildInputs = [ pkgs.bash ];

  installPhase = ''
    runHook preInstall
    PREFIX=$out ./install
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
