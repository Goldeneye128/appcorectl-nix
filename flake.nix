{
  description = "Nix packaging for appcorectl";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachSystem [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ] (system:
      let
        pkgs = import nixpkgs { inherit system; };
        src = pkgs.fetchFromGitHub {
          owner = "Goldeneye128";
          repo = "appcoreos";
          rev = "1d9f0d827d99e8da6f526e74f80e14fe0f13d1a9";
          hash = "sha256-edhPJ/4Ge+fvh3iRLbTt3Qh3X1NJVZoErRIH7MJfMCY=";
        };
        package = pkgs.rustPlatform.buildRustPackage {
          pname = "appcorectl";
          version = "0.2.0";
          src = src;
          sourceRoot = "source/appcorectl";
          nativeBuildInputs = [ pkgs.openssl ];
          cargoLock = {
            lockFile = "${src}/appcorectl/Cargo.lock";
          };

          meta = with pkgs.lib; {
            description = "Official operator CLI for AppCoreOS lifecycle management";
            homepage = "https://github.com/Goldeneye128/appcoreos/tree/main/appcorectl";
            license = licenses.gpl3Only;
            mainProgram = "appcorectl";
            platforms = platforms.unix;
          };
        };
      in {
        packages.default = package;
        packages.appcorectl = package;
        apps.default = flake-utils.lib.mkApp {
          drv = package;
        };
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            cargo
            clippy
            rustc
            rustfmt
          ];
        };
      });
}
