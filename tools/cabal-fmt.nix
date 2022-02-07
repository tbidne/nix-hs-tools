{ pkgs }:

pkgs.writeShellScript "cabal-fmt.sh" ''
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

  find $dir -name '*.cabal' | xargs ${pkgs.haskellPackages.cabal-fmt}/bin/cabal-fmt ''${args[@]}
''
