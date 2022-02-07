{
  description = "Haskell Development Tools Provided by Nix";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  outputs =
    { flake-utils
    , nixpkgs
    , self
    }:
    flake-utils.lib.eachDefaultSystem (system:
    let
      haskell-overlay = final: prev: {
        ormolu = final.haskell.packages.ghc921.ormolu_0_4_0_0;

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
      cabal-fmt = import ./tools/cabal-fmt.nix { inherit pkgs; };
      hie = import ./tools/hie.nix { inherit pkgs; };
      hlint = import ./tools/hlint.nix { inherit pkgs; };
      haddock_8-10-7 = import ./tools/haddock/8-10-7.nix { inherit pkgs; };
      haddock_9-0-2 = import ./tools/haddock/9-0-2.nix { inherit pkgs; };
      haddock_9-2-1 = import ./tools/haddock/9-2-1.nix { inherit pkgs; };
      nixpkgs-fmt = import ./tools/nixpkgs-fmt.nix { inherit pkgs; };
      ormolu = import ./tools/ormolu.nix { inherit pkgs; };
      stylish = import ./tools/stylish.nix { inherit pkgs; };
    in
    {
      apps.cabal-fmt = {
        type = "app";
        program = "${cabal-fmt}";
      };
      apps.hie = {
        type = "app";
        program = "${hie}";
      };
      apps.hlint = {
        type = "app";
        program = "${hlint}";
      };
      apps.haddock_8-10-7 = {
        type = "app";
        program = "${haddock_8-10-7}";
      };
      apps.haddock_9-0-2 = {
        type = "app";
        program = "${haddock_9-0-2}";
      };
      apps.haddock_9-2-1 = {
        type = "app";
        program = "${haddock_9-2-1}";
      };
      apps.nixpkgs-fmt = {
        type = "app";
        program = "${nixpkgs-fmt}";
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
