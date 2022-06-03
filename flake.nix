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

      # misc
      title = "Nix-HS-Tools";
      desc = ''
        Nix-HS-Tools uses nix to provide tools for haskell development. To \
        see a tool's individual usage, pass the '--nh-help' arg e.g. \n\n\t\
        $ nix run github:tbidne/nix-hs-tools#ormolu -- --nh-help \n\t\
        nix run github:tbidne/nix-hs-tools#ormolu -- [--dir PATH] [--no-cabal] <args> \n\n\
        See github.com/tbidne/nix-hs-tools#readme.
      '';
      version = "Version: 0.3";

      # tools
      cabal-fmt = import ./tools/cabal-fmt.nix { inherit pkgs; };
      fourmolu = import ./tools/fourmolu.nix { inherit pkgs find-hs-non-build; };
      hie = import ./tools/hie.nix { inherit pkgs; };
      hlint = import ./tools/hlint.nix { inherit pkgs; };
      haddock = import ./tools/haddock.nix { inherit pkgs; };
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
      apps.help = {
        type = "app";
        program = "${pkgs.writeShellScript "help.sh" ''
          echo -e "${title}: Haskell Development Tools Provided by Nix\n"
          echo -e "Usage: nix run github:tbidne/nix-hs-tools#<tool> -- <args>\n"
          echo -e "${desc}"
          echo ${version}
        ''}";
      };
      apps.hie = {
        type = "app";
        program = "${hie}";
      };
      apps.hlint = {
        type = "app";
        program = "${hlint}";
      };
      apps.haddock = {
        type = "app";
        program = "${haddock}";
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
          echo ${title}
          echo ${version}
        ''}";
      };

      devShells.${system} = pkgs.mkShell {
        buildInputs = [ pkgs.nixpkgs-fmt ];
      };
    });
}
