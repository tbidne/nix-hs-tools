{ compiler
, nix-hs-utils
, pkgs
}:

nix-hs-utils.mkShellApp {
  inherit pkgs;
  name = "fourmolu";
  text = ''
    set -e
    args=()
    dir=.
    while [ $# -gt 0 ]; do
      if [[ $1 == "--nh-help" ]]; then
        echo "usage: fourmolu [--dir PATH] <args>"
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
    ${compiler.fourmolu}/bin/fourmolu "''${args[@]}" $(${pkgs.fd}/bin/fd "$dir" -e hs)
  '';
  runtimeInputs = [ compiler.fourmolu pkgs.fd ];
}
