{ pkgs
, find-hs-non-build
}:

pkgs.writeShellScript "fourmolu.sh" ''
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
  ${find-hs-non-build} | xargs ${pkgs.fourmolu}/bin/fourmolu $cabal ''${args[@]}
''
