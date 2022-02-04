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
      hlint = import ./tools/hlint.nix { inherit pkgs; };
      ormolu = import ./tools/ormolu.nix { inherit pkgs; };
      stylish = import ./tools/stylish.nix { inherit pkgs; };
    in
    {
      apps.hlint = {
        type = "app";
        program = "${hlint}";
      };
      apps.ormolu = {
        type = "app";
        program = "${ormolu}";
      };
      apps.stylish = {
        type = "app";
        program = "${stylish}";
      };

      devShell = pkgs.mkShell {
        buildInputs = [ pkgs.nixpkgs-fmt ];
      };
    });
}
