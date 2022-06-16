{ pkgs
, find-hs-non-build
}:

pkgs.writeShellScript "fourmolu.sh" ''
  set -e
  args=()
  dir=.
  while [ $# -gt 0 ]; do
    if [[ $1 == "--nh-help" ]]; then
      echo "usage: nix run github:tbidne/nix-hs-tools#fourmolu -- [--dir PATH] <args>"
      exit 0
    elif [[ $1 == "--dir" ]]; then
      dir=$2
      shift
    else
      args+=($1)
    fi
    shift
  done

  ${find-hs-non-build} | ${pkgs.findutils}/bin/xargs \
    ${pkgs.fourmolu}/bin/fourmolu ''${args[@]}
''
