{ pkgs }:

pkgs.writeShellScript "ormolu.sh" ''
  dir=.
  cabal="--cabal-default-extensions"
  args=()
  while [ $# -gt 0 ]; do
    if [[ $1 == "--dir" ]]; then
      dir=$2
      shift
    elif [[ $1 == "--no-cabal" ]]; then
      cabal=""
    else
      args+=($1)
    fi
    shift
  done
  find $dir -type d \( -name dist-newstyle -o -name stack-work \) -prune -false -o -name '*.hs' | xargs ${pkgs.ormolu}/bin/ormolu $cabal ''${args[@]}
''
