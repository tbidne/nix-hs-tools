{ pkgs }:

pkgs.writeShellScript "cabal-fmt.sh" ''
  ${pkgs.haskellPackages.cabal-fmt}/bin/cabal-fmt ''${@:1}
''
