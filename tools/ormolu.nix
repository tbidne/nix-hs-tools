{ pkgs
, find-hs-non-build
}:

pkgs.writeShellScript "ormolu.sh" ''
  set -e
  args=()
  dir=.
  while [ $# -gt 0 ]; do
    if [[ $1 == "--nh-help" ]]; then
      echo "usage: ormolu [--dir PATH] <args>"
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
    ${pkgs.ormolu}/bin/ormolu ''${args[@]}
''
