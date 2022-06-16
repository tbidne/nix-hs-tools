{ pkgs }:

pkgs.writeShellScript "hie.sh" ''
  set -e
  if [[ $1 == "--nh-help" ]]; then
    echo "usage: nix run github:tbidne/nix-hs-tools#hie"
    exit 0
  fi
  ${pkgs.haskellPackages.implicit-hie}/bin/gen-hie > hie.yaml
''
