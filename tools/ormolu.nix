{ compiler, nix-hs-utils, pkgs }:

nix-hs-utils.mkShellApp {
  inherit pkgs;
  name = "ormolu";
  text = ''
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
        args+=("$1")
      fi
      shift
    done

    # shellcheck disable=SC2046
    ${compiler.ormolu}/bin/ormolu "''${args[@]}" $(${pkgs.fd}/bin/fd "$dir" -e hs)
  '';
  runtimeInputs = [ compiler.ormolu pkgs.fd ];
}
