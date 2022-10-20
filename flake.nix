{
  description = "Haskell Development Tools by Nix";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  # Here is a problem. We would like to update our tools, which involves
  # updating nixpkgs. This updates GHC from 9.2.3 to 9.2.4. Unfortunately,
  # the hlint in this repository no longer builds since it depends on a
  # different minor version.
  #
  # HLint 3.5 actually works withghc 9.4.2 (also in nixpkgs), but we would
  # like to keep all tools on the same GHC, for simplicity. Thus we add
  # the older nixpkgs input, solely to be able to use the 9.2 hlint w/ the rest
  # of our 9.2 tools.
  inputs.nixpkgs-hlint.url = "github:nixos/nixpkgs?rev=e0169d7a9d324afebf5679551407756c77af8930";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  outputs =
    { flake-utils
    , nixpkgs
    , nixpkgs-hlint
    , self
    }:
    flake-utils.lib.eachDefaultSystem (system:
    let
      haskell-overlay = final: prev:
        let
          hp = final.pkgs.haskell.packages.ghc924;
        in
        {
          # overrides
          fourmolu = hp.fourmolu_0_8_2_0;
          ormolu = hp.ormolu_0_5_0_1;

          # adding to pkgs so we can easily access versions.
          cabal-fmt = hp.cabal-fmt;
          implicit-hie = hp.implicit-hie;

          # disable all tests
          mkDerivation = args: prev.mkDerivation (args // {
            doCheck = false;
          });
        };
      hlint-overlay = final: prev:
        let
          hp = final.pkgs.haskell.packages.ghc923;
        in
        {
          apply-refact = hp.apply-refact_0_10_0_0;
          hlint = hp.hlint_3_4;
        };

      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          haskell-overlay
        ];
      };
      pkgs-hlint = import nixpkgs-hlint {
        inherit system;
        overlays = [
          hlint-overlay
        ];
      };

      # convenient aliases used in multiple tools
      excluded-dirs = "! -path \"./.*\" ! -path \"./*dist-newstyle/*\" ! -path \"./*stack-work/*\"";
      find-hs-non-build = "${pkgs.findutils}/bin/find $dir -type f -name \"*.hs\" ${excluded-dirs}";

      # misc
      title = "nix-hs-tools";
      desc = ''
        Nix-hs-tools uses nix to provide tools for haskell development.
        In general, we take some 3rd party tool (e.g. ormolu) and provide it with nix,
        along with some extra functionality "on top" for convenience.\n
        To see a tool's individual usage, pass the '--nh-help' arg e.g.

        \t$ nix run github:tbidne/nix-hs-tools#ormolu -- --nh-help
        \tnix run github:tbidne/nix-hs-tools#ormolu -- [--dir PATH] <args>

        Note that the tools themselves generally have their own builtin-help pages
        with more detail:

        \t$ nix run github:tbidne/nix-hs-tools#ormolu -- --help
        \tUsage: ormolu ...

        Tools:
        \tHaskell Formatters:
        \t  - cabal-fmt:   ${pkgs.cabal-fmt.version}
        \t  - fourmolu:    ${pkgs.fourmolu.version}
        \t  - ormolu:      ${pkgs.ormolu.version}
        \t  - stylish:     ${pkgs.stylish-haskell.version}
        \tHaskell Linters:
        \t  - hlint:       ${pkgs.hlint.version}
        \tHaskell Miscellaneous:
        \t  - haddock-cov: ${haddock-cov.version}
        \t  - hie:         ${pkgs.implicit-hie.version}
        \tNix Formatters:
        \t  - nixpkgs-fmt: ${pkgs.nixpkgs-fmt.version}
        \tInformation:
        \t  - help
        \t  - version
        See github.com/tbidne/nix-hs-tools#readme.
      '';
      version = "0.7";

      # tools
      cabal-fmt = import ./tools/cabal-fmt.nix { inherit pkgs excluded-dirs; };
      fourmolu = import ./tools/fourmolu.nix { inherit pkgs find-hs-non-build; };
      hie = import ./tools/hie.nix { inherit pkgs; };
      hlint = import ./tools/hlint.nix { inherit find-hs-non-build; pkgs = pkgs-hlint; };
      haddock-cov = import ./tools/haddock-cov.nix { inherit pkgs; };
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
      apps.haddock-cov = {
        type = "app";
        program = "${haddock-cov.script}";
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
