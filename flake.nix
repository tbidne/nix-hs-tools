{
  description = "Haskell Development Tools by Nix";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  outputs =
    { flake-utils
    , nixpkgs
    , self
    }:
    flake-utils.lib.eachDefaultSystem (system:
    let
      haskell-overlay = final: prev:
        let hp = final.pkgs.haskell.packages.ghc923; in
        {
          apply-refact = hp.apply-refact_0_10_0_0;
          fourmolu = hp.fourmolu_0_7_0_1;
          hlint = hp.hlint_3_4;
          ormolu = hp.ormolu_0_5_0_0;

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
      excluded-dirs = "! -path \"./.*\" ! -path \"./*dist-newstyle/*\" ! -path \"./*stack-work/*\"";
      find-hs-non-build = "${pkgs.findutils}/bin/find $dir -type f -name \"*.hs\" ${excluded-dirs}";

      # misc
      title = "nix-hs-tools";
      desc = ''
        nix-hs-tools uses nix to provide tools for haskell development. To \
        see a tool's individual usage, pass the '--nh-help' arg e.g. \n\n\t\
        $ nix run github:tbidne/nix-hs-tools#ormolu -- --nh-help \n\t\
        nix run github:tbidne/nix-hs-tools#ormolu -- [--dir PATH] <args> \n\n\
        Tools:\n\
        \tHaskell Formatters:
        \t  - cabal-fmt: 0.1.5.1\n\
        \t  - fourmolu: 0.7.0.1\n\
        \t  - ourmolu: 0.5.0.0\n\
        \t  - stylish: 0.14.2.0\n\
        \tHaskell Linters:
        \t  - hlint: 3.4\n\
        \tHaskell Miscellaeous:
        \t  - haddock\n\
        \t  - hie: 0.1.2.7\n\
        \tNix Formatters:
        \t  - nixpkgs-fmt: 1.2.0\n\
        \tInformation:
        \t  - help\n\
        \t  - version\n\
        See github.com/tbidne/nix-hs-tools#readme.
      '';
      version = "0.4";

      # tools
      cabal-fmt = import ./tools/cabal-fmt.nix { inherit pkgs; };
      fourmolu = import ./tools/fourmolu.nix { inherit pkgs find-hs-non-build; };
      hie = import ./tools/hie.nix { inherit pkgs; };
      hlint = import ./tools/hlint.nix { inherit pkgs find-hs-non-build; };
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
          echo -e "${title}: Haskell development tools by Nix\n"
          echo -e "Usage: nix run github:tbidne/nix-hs-tools#<tool> -- <args>\n"
          echo -e "${desc}"
          echo Version: ${version}
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
          echo ${title} ${version}
        ''}";
      };
    });
}
