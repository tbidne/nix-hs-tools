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
        fourmolu = final.haskell.packages.ghc922.fourmolu_0_6_0_0;
        ormolu = final.haskell.packages.ghc922.ormolu_0_4_0_0;

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
      find-hs-non-build = "find $dir -type f -name \"*.hs\" ! -path \"./.*\" ! -path \"./*dist-newstyle/*\" ! -path \"./*stack-work/*\"";
      cabal-fmt = import ./tools/cabal-fmt.nix { inherit pkgs; };
      fourmolu = import ./tools/fourmolu.nix { inherit pkgs find-hs-non-build; };
      hie = import ./tools/hie.nix { inherit pkgs; };
      hlint = import ./tools/hlint.nix { inherit pkgs; };
      haddock_8-10 = import ./tools/haddock/8-10.nix { inherit pkgs; };
      haddock_9-0 = import ./tools/haddock/9-0.nix { inherit pkgs; };
      haddock_9-2 = import ./tools/haddock/9-2.nix { inherit pkgs; };
      nixpkgs-fmt = import ./tools/nixpkgs-fmt.nix { inherit pkgs; };
      ormolu = import ./tools/ormolu.nix { inherit pkgs find-hs-non-build; };
      stylish = import ./tools/stylish.nix { inherit pkgs find-hs-non-build; };
    in
    {
      apps.cabal-fmt = {
        type = "app";
        program = "${cabal-fmt}";
      };
      apps.fourmolu = {
        type = "app";
        program = "${fourmolu}";
      };
      apps.hie = {
        type = "app";
        program = "${hie}";
      };
      apps.hlint = {
        type = "app";
        program = "${hlint}";
      };
      apps.haddock_8-10 = {
        type = "app";
        program = "${haddock_8-10}";
      };
      apps.haddock_9-0 = {
        type = "app";
        program = "${haddock_9-0}";
      };
      apps.haddock_9-2 = {
        type = "app";
        program = "${haddock_9-2}";
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
      apps.version = {
        type = "app";
        program = "${pkgs.writeShellScript "version.sh" ''
          echo nix-hs-tools
          echo version: 0.2
        ''}";
      };

      devShells.${system} = pkgs.mkShell {
        buildInputs = [ pkgs.nixpkgs-fmt ];
      };
    });
}
