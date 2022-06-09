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
      overrideIndex = haskellPackages': haskellPackages'.override {
        all-cabal-hashes = builtins.fetchurl {
          url = "https://github.com/commercialhaskell/all-cabal-hashes/archive/993091a69d0159755a87966c35d1b0fb2db6e01a.tar.gz";
          sha256 = "0sas431dpk895mg0yz9z13sx9vcg3zjf866xlav0rd2c658a730l";
        };
      };

      haskell-overlay = final: prev:
        let hp = final.pkgs.haskell.packages.ghc922; in
        {
          # want the latest but not in the current nixpkgs, unfortunately
          fourmolu = final.pkgs.haskell.lib.dontCheck
            ((overrideIndex hp).callHackage "fourmolu" "0.7.0.1" { });
          hlint = (overrideIndex hp).callHackage "hlint" "3.4" { };

          # in nixpkgs
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
        See github.com/tbidne/nix-hs-tools#readme.
      '';
      version = "Version: 0.3";

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
    });
}
