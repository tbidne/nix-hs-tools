{ pkgs
, find-hs-non-build
}:

pkgs.writeShellScript "stylish.sh" ''
  set -e
  args=()
  dir=.
  while [ $# -gt 0 ]; do
    if [[ $1 == "--nh-help" ]]; then
      echo "usage: stylish [--dir PATH] <args>"
      exit 0
    elif [[ $1 == "--dir" ]]; then
      dir=$2
      shift 1
    else
      args+=($1)
    fi
    shift
  done

  ${find-hs-non-build} | ${pkgs.findutils}/bin/xargs \
    ${pkgs.stylish-haskell}/bin/stylish-haskell ''${args[@]}
''
