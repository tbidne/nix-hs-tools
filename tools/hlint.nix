{ pkgs }:

pkgs.writeShellScript "hlint.sh" ''
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

  ${pkgs.hlint}/bin/hlint $dir --ignore-glob=dist-newstyle --ignore-glob=stack-work ''${args[@]}
''
