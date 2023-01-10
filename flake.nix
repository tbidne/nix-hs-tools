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
        let
          hp = final.pkgs.haskell.packages.ghc944;
        in
        {
          # overrides
          apply-refact = hp.apply-refact_0_11_0_0;
          # TODO: Update
          fourmolu = hp.fourmolu_0_8_2_0;
          ormolu = hp.ormolu_0_5_2_0;
          hlint = hp.hlint_3_5;

          # adding to pkgs so we can easily access versions.
          cabal-fmt = hp.cabal-fmt;
          implicit-hie = hp.implicit-hie;

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
      version = "0.8";

      # tools
      cabal-fmt = import ./tools/cabal-fmt.nix { inherit pkgs excluded-dirs; };
      fourmolu = import ./tools/fourmolu.nix { inherit pkgs find-hs-non-build; };
      hie = import ./tools/hie.nix { inherit pkgs; };
      hlint = import ./tools/hlint.nix { inherit find-hs-non-build pkgs; };
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
