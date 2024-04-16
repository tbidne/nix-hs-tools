{
  compiler,
  nix-hs-utils,
  pkgs,
}:

nix-hs-utils.mkShellApp {
  inherit pkgs;
  name = "stylish";
  text = ''
    set -e
    args=()
    dir=.
    while [ $# -gt 0 ]; do
      if [[ $1 == "--nh-help" ]]; then
        echo "usage: stylish [--dir PATH] <args>"
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
    stylish-haskell "''${args[@]}" $(fd "$dir" -e hs)
  '';
  runtimeInputs = [
    compiler.stylish-haskell
    pkgs.fd
  ];
}
