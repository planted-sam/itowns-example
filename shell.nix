{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShell {
  buildInputs = [
    pkgs.deno
  ];

  # Starts up app in dev mode
  shellHook = ''
    deno install
    export MAPTILER_API_KEY=<ask sam>
    deno run dev
  '';
}