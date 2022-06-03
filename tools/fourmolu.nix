{ pkgs
, find-hs-non-build
}:

pkgs.writeShellScript "fourmolu.sh" ''
  args=()
  cabal="--cabal-default-extensions"
  dir=.
  while [ $# -gt 0 ]; do
    if [[ $1 == "--nh-help" ]]; then
      echo "usage: nix run github:tbidne/nix-hs-tools#fourmolu -- [--dir PATH] [--no-cabal] <args>"
      exit 0
    elif [[ $1 == "--dir" ]]; then
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
