{
  description = "A very basic shiny flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      rEnv = pkgs.rWrapper.override {
        packages = with pkgs.rPackages; [
          languageserver
          S7
          R6
          microbenchmark
          shiny
        ];
      };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          rEnv
          air-formatter
          jarl
          nixfmt
          nil
        ];
      };
      formatter.${system} = pkgs.writeShellApplication {
        name = "custom-formatter";
        runtimeInputs = [
          pkgs.air-formatter
          pkgs.nixfmt
        ];
        text = ''
          nixfmt flake.nix
          air format .
        '';
      };
    };
}
