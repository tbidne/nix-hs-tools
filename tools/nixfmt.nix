{ nix-hs-utils, pkgs }:

nix-hs-utils.mkShellApp {
  inherit pkgs;
  name = "nixfmt";
  text = ''
    set -e
    args=()
    dir=.
    while [ $# -gt 0 ]; do
      if [[ $1 == "--nh-help" ]]; then
        echo "usage: nixfmt [--dir PATH] <args>"
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
    nixfmt "''${args[@]}" $(fd "$dir" -e nix)
  '';
  runtimeInputs = [ pkgs.fd pkgs.nixfmt-rfc-style ];
}
