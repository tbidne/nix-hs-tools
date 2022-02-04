{ pkgs }:

pkgs.writeShellScript "hlint.sh" ''
  ${pkgs.hlint}/bin/hlint ''${@:1}
''
