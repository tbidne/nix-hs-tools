{ pkgs }:

pkgs.writeShellScript "stylish.sh" ''
  dir=.
  args=()
  while [ $# -gt 0 ]; do
    if [[ $1 == "--dir" ]]; then
      dir=$2
      shift 1
    else
      args+=($1)
    fi
    shift
  done
  find $dir -type d \( -name dist-newstyle -o -name stack-work \) -prune -false -o -name '*.hs' | xargs ${pkgs.stylish-haskell}/bin/stylish-haskell ''${args[@]}
''
