{ pkgs
, find-hs-non-build
}:

pkgs.writeShellScript "stylish.sh" ''
  args=()
  dir=.
  while [ $# -gt 0 ]; do
    if [[ $1 == "--nh-help" ]]; then
      echo "usage: nix run github:tbidne/nix-hs-tools#stylish -- [--dir PATH] <args>"
      exit 0
    elif [[ $1 == "--dir" ]]; then
      dir=$2
      shift 1
    else
      args+=($1)
    fi
    shift
  done

  ${find-hs-non-build} | xargs ${pkgs.stylish-haskell}/bin/stylish-haskell ''${args[@]}
''
