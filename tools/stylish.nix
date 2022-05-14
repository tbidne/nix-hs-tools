{ pkgs
, find-hs-non-build
}:

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
  ${find-hs-non-build} | xargs ${pkgs.stylish-haskell}/bin/stylish-haskell ''${args[@]}
''
