{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  bun,
  nodejs,
}:

buildNpmPackage rec {
  pname = "cspell-lsp";
  version = "1.1.5";

  src = fetchFromGitHub {
    owner = "vlabo";
    repo = "cspell-lsp";
    rev = "v${version}";
    hash = "sha256-mypKJb3/MOp2ldOQq1KgfrHotuAXCP2nRWGLhVJeR/I=";
  };

  npmDepsHash = "sha256-XYgtV3XMEriMjC06QfudL0fyoTY1PobnpUf4PQGOA2U=";

  buildInputs = [ nodejs ];

  nativeBuildInputs = [
    bun
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mkdir -p $out/lib/cspell-lsp

    # Copy the built JS file
    cp dist/cspell-lsp.js $out/lib/cspell-lsp/

    # Copy all production node_modules
    # The bundled JS has most code included, but dictionaries (.trie.gz files)
    # and some dynamically imported modules need to be available at runtime
    cp -r node_modules $out/lib/cspell-lsp/

    # Copy package.json for metadata
    cp package.json $out/lib/cspell-lsp/

    # Create wrapper script that sets up the environment
    cat > $out/bin/${meta.mainProgram} <<EOF
    #!/bin/sh
    exec ${nodejs}/bin/node $out/lib/cspell-lsp/cspell-lsp.js "\$@"
    EOF
    chmod +x $out/bin/${meta.mainProgram}

    runHook postInstall
  '';

  meta = with lib; {
    description = "Spell checker language server using cspell";
    longDescription = ''
      A language server for spell checking in source code using the cspell library.
      Works with editors that support LSP such as Neovim, Helix, and VSCode.
      Supports configuration via cspell.json files.
    '';
    homepage = "https://github.com/vlabo/cspell-lsp";
    changelog = "https://github.com/vlabo/cspell-lsp/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ]; # Add your name here
    mainProgram = "cspell-lsp";
    platforms = platforms.all;
  };
}
