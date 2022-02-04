{ pkgs }:

pkgs.writeShellScript "hie.sh" ''
  ${pkgs.haskellPackages.implicit-hie}/bin/gen-hie > hie.yaml
''
