{ excluded-dirs
, pkgs
}:

let
  find-cabal-non-build = "${pkgs.findutils}/bin/find $dir -type f -name \"*.cabal\" ${excluded-dirs}";
in pkgs.writeShellScript "cabal-fmt.sh" ''
  args=()
  dir=.
  while [ $# -gt 0 ]; do
    if [[ $1 == "--nh-help" ]]; then
      echo "usage: nix run github:tbidne/nix-hs-tools#cabal-fmt -- [--dir PATH] <args>"
      exit 0
    elif [[ $1 == "--dir" ]]; then
      dir=$2
      shift 1
    else
      args+=($1)
    fi
    shift
  done

  ${find-cabal-non-build} | ${pkgs.findutils}/bin/xargs \
    ${pkgs.haskellPackages.cabal-fmt}/bin/cabal-fmt ''${args[@]}
''
