{
  compiler,
  nix-hs-utils,
  pkgs,
}:

# NOTE: [Exe reference]
#
# For some reason, referencing bare ormolu below in the script is better
# than writing ${compiler.ormolu}/bin/ormolu, as the latter does not actually
# exist.

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
    ormolu "''${args[@]}" $(fd "$dir" -e hs)
  '';
  runtimeInputs = [
    compiler.ormolu
    pkgs.fd
  ];
}
