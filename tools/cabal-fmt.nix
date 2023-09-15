{ compiler
, nix-hs-utils
, pkgs
}:

nix-hs-utils.mkShellApp {
  inherit pkgs;
  name = "cabal-fmt";
  text = ''
    set -e
    args=()
    dir=.
    while [ $# -gt 0 ]; do
      if [[ $1 == "--nh-help" ]]; then
        echo "usage: cabal-fmt [--dir PATH] <args>"
        exit 0
      elif [[ $1 == "--dir" ]]; then
        dir=$2
        shift 1
      else
        args+=("$1")
      fi
      shift
    done

    # shellcheck disable=SC2046
    ${compiler.cabal-fmt}/bin/cabal-fmt "''${args[@]}" $(${pkgs.fd}/bin/fd "$dir" -e cabal)
  '';
  runtimeInputs = [ compiler.cabal-fmt pkgs.fd ];
}