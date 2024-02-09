{ nix-hs-utils, pkgs }:

nix-hs-utils.mkShellApp {
  inherit pkgs;
  name = "nixpkgs-fmt";
  text = ''
    set -e
    args=()
    dir=.
    while [ $# -gt 0 ]; do
      if [[ $1 == "--nh-help" ]]; then
        echo "usage: nixpkgs-fmt [--dir PATH] <args>"
        exit 0
      elif [[ $1 == "--dir" ]]; then
        dir=$2
        shift 1
      else
        args+=("$1")
      fi
      shift
    done

    # shellcheck disable=SC2086
    ${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt $dir "''${args[@]}"
  '';
  runtimeInputs = [ pkgs.nixpkgs-fmt ];
}
