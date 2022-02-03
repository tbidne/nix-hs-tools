{ pkgs }:

pkgs.writeShellScript "ormolu.sh" ''
  dir=$1
  find $dir -type d \( -name dist-newstyle -o -name stack-work \) -prune -false -o -name '*.hs' | xargs ${pkgs.ormolu}/bin/ormolu ''${@:2}
''
