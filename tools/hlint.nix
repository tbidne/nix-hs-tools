{ pkgs }:

pkgs.writeShellScript "hlint.sh" ''
  args=()
  dir=.
  while [ $# -gt 0 ]; do
    if [[ $1 == "--nh-help" ]]; then
      echo "usage: nix run github:tbidne/nix-hs-tools#hlint -- [--dir PATH] <args>"
      exit 0
    elif [[ $1 == "--dir" ]]; then
      dir=$2
      shift 1
    else
      args+=($1)
    fi
    shift
  done

  ${pkgs.hlint}/bin/hlint $dir --ignore-glob=dist-newstyle --ignore-glob=stack-work ''${args[@]}
''
