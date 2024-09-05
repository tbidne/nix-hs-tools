{
  description = "Haskell Development Tools by Nix";
  inputs.flake-parts.url = "github:hercules-ci/flake-parts";
  inputs.nix-hs-utils.url = "github:tbidne/nix-hs-utils";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  outputs =
    inputs@{
      flake-parts,
      nix-hs-utils,
      nixpkgs,
      self,
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      perSystem =
        { pkgs, ... }:
        let
          hlib = pkgs.haskell.lib;

          # FIXME: The following issues need to be resolved before we can release:
          #
          # - New hlint release
          #   - See https://github.com/ndmitchell/hlint/issues/1613
          #
          # - cabal-plan is broken
          #
          # - New stylish release
          #   - https://github.com/haskell/stylish-haskell/issues/479
          #
          ghcVers = "ghc9101";
          compiler = pkgs.haskell.packages."${ghcVers}".override {
            overrides = final: prev: {
              # cabal-plan needs ansi-terminal > 1.0.2. Note that all of our
              # haskell tools are OK with the default ansi-terminal, so make
              # sure overriding this does not destory caching for other
              # tools.
              ansi-terminal = prev.ansi-terminal_1_1_1;
              ansi-terminal-types = prev.ansi-terminal-types_1_1;

              # NOTE: Disabling test failures as the suite current fails
              # due to different call stack output (i.e. it probably
              # doesn't matter to us).
              call-stack = hlib.dontCheck prev.call-stack;

              cabal-plan = prev.cabal-plan_0_7_4_0;
              fourmolu = prev.fourmolu_0_16_2_0;
              # FIXME: Need a newer version of hlint for GHC 9.10
              # (presumably 3.10). Currently waiting for this to be released
              # to hackage, then make it to nixpkgs...
              #
              #     https://github.com/ndmitchell/hlint/issues/1613
              hlint = prev.hlint_3_8;
              ormolu = prev.ormolu_0_7_7_0;
              stylish-haskell = prev.stylish-haskell_0_14_6_0;
            };
          };

          pkgsUtils = {
            inherit nix-hs-utils pkgs;
          };

          compilerPkgs = {
            inherit compiler nix-hs-utils pkgs;
          };

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
            \t  - cabal-plan:  ${compiler.cabal-plan.version}
            \t  - hie:         ${compiler.implicit-hie.version}
            \tNix Formatters:
            \t  - nixfmt:      ${pkgs.nixfmt-rfc-style.version}
            \t  - nixpkgs-fmt: ${pkgs.nixpkgs-fmt.version}
            \Other:
            \t  - prettier:    ${pkgs.nodePackages.prettier.version}
            \t  - yamllint:    ${pkgs.yamllint.version}
            \tInformation:
            \t  - help
            \t  - version
            See github.com/tbidne/nix-hs-tools#readme.
          '';
          version = "0.11";
        in
        {
          apps = {
            cabal-plan = import ./tools/cabal-plan.nix compilerPkgs;
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
            nixfmt = import ./tools/nixfmt.nix pkgsUtils;
            nixpkgs-fmt = import ./tools/nixpkgs-fmt.nix pkgsUtils;
            ormolu = import ./tools/ormolu.nix compilerPkgs;
            prettier = import ./tools/prettier.nix pkgsUtils;
            stylish = import ./tools/stylish.nix compilerPkgs;
            yamllint = import ./tools/yamllint.nix pkgsUtils;
            version = {
              type = "app";
              program = "${pkgs.writeShellScript "version.sh" ''
                echo ${title} ${version}
              ''}";
            };
          };
        };
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];
    };
}
