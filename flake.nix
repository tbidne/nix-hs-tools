{
  description = "Haskell Development Tools Provided by Nix";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  outputs =
    { flake-utils
    , nixpkgs
    , self
    }:
    flake-utils.lib.eachSystem [ "x86_64-linux" "x86_64-darwin" ] (system:
    let
      haskell-overlay = final: prev: {
        ormolu = final.haskell.packages.ghc921.callHackage "ormolu" "0.4.0.0" { };

        # disable all tests
        mkDerivation = args: prev.mkDerivation (args // {
          doCheck = false;
        });
      };
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          haskell-overlay
        ];
      };
      ormolu = import ./tools/ormolu.nix { inherit pkgs; };
    in
    {
      apps.ormolu = {
        type = "app";
        program = "${ormolu}";
      };

      devShell = pkgs.mkShell {
        buildInputs = [ pkgs.nixpkgs-fmt ];
      };
    });
}
