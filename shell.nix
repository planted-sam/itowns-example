{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShell {
  buildInputs = [
    pkgs.deno
  ];

  # Starts up app in dev mode
  shellHook = ''
    deno install
    deno run dev
  '';
}