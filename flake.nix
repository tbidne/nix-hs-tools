{
  description = "Haskell Development Tools by Nix";
  inputs.flake-parts.url = "github:hercules-ci/flake-parts";
  inputs.nix-hs-utils.url = "github:tbidne/nix-hs-utils";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  outputs =
    inputs@{ flake-parts
    , nix-hs-utils
    , nixpkgs
    , self
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      perSystem = { pkgs, ... }:
        let
          ghcVers = "ghc962";
          compiler = pkgs.haskell.packages."${ghcVers}".override {
            overrides = final: prev: {
              # For some reason, the cabal-fmt in nixpkgs does not have /bin
              # i.e. no executable.
              cabal-fmt = final.callHackage "cabal-fmt" "0.1.7" { };
              implicit-hie = prev.implicit-hie_0_1_4_0;
            };
          };

          compilerPkgs = { inherit compiler nix-hs-utils pkgs; };

          # misc
          title = "nix-hs-tools";
          desc = ''
            Nix-hs-tools uses nix to provide tools for haskell development.
            In general, we take some 3rd party tool (e.g. ormolu) and provide it with nix,
            along with some extra functionality 'on top' for convenience.\n
            To see a tool's individual usage, pass the '--nh-help' arg e.g.

            \t$ nix run github:tbidne/nix-hs-tools#ormolu -- --nh-help
            \tnix run github:tbidne/nix-hs-tools#ormolu -- [--dir PATH] <args>

            Note that the tools themselves generally have their own builtin-help pages
            with more detail:

            \t$ nix run github:tbidne/nix-hs-tools#ormolu -- --help
            \tUsage: ormolu ...

            Tools:
            \tHaskell Formatters:
            \t  - cabal-fmt:   ${compiler.cabal-fmt.version}
            \t  - fourmolu:    ${compiler.fourmolu.version}
            \t  - ormolu:      ${compiler.ormolu.version}
            \t  - stylish:     ${compiler.stylish-haskell.version}
            \tHaskell Linters:
            \t  - hlint:       ${compiler.hlint.version}
            \tHaskell Miscellaneous:
            \t  - hie:         ${compiler.implicit-hie.version}
            \tNix Formatters:
            \t  - nixpkgs-fmt: ${pkgs.nixpkgs-fmt.version}
            \tInformation:
            \t  - help
            \t  - version
            See github.com/tbidne/nix-hs-tools#readme.
          '';
          version = "0.9.0.1";
        in
        {
          apps = {
            cabal-fmt = import ./tools/cabal-fmt.nix compilerPkgs;
            fourmolu = import ./tools/fourmolu.nix compilerPkgs;

            help = nix-hs-utils.mkShellApp {
              inherit pkgs;
              name = "help";
              text = ''
                echo -e "${title}: Haskell development tools by Nix\n"
                echo -e "Usage: nix run github:tbidne/nix-hs-tools#<tool> -- <args>\n"
                echo -e "${desc}"
                echo Version: ${version}
              '';
              runtimeInputs = [ ];
            };

            hie = import ./tools/hie.nix compilerPkgs;
            hlint = import ./tools/hlint.nix compilerPkgs;
            nixpkgs-fmt = import ./tools/nixpkgs-fmt.nix { inherit nix-hs-utils pkgs; };
            ormolu = import ./tools/ormolu.nix compilerPkgs;
            stylish = import ./tools/stylish.nix compilerPkgs;
            version = {
              type = "app";
              program = "${pkgs.writeShellScript "version.sh" ''
              echo ${title} ${version}
            ''}";
            };
          };
        };
      systems = [
        "x86_64-darwin"
        "x86_64-linux"
      ];
    };
}
