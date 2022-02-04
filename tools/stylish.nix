{ pkgs }:

pkgs.writeShellScript "stylish.sh" ''
  ${pkgs.stylish-haskell}/bin/stylish-haskell ''${@:2}
''
