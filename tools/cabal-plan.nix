{
  compiler,
  nix-hs-utils,
  pkgs,
}:

nix-hs-utils.mkShellApp {
  inherit pkgs;
  name = "cabal-plan";
  text = ''
    set -e
    args=()
    while [ $# -gt 0 ]; do
      if [[ $1 == "--nh-help" ]]; then
        echo "usage: cabal-plan <args>"
        exit 0
      else
        args+=("$1")
      fi
      shift
    done

    cabal-plan "''${args[@]}"
  '';
  runtimeInputs = [
    compiler.cabal-plan
    pkgs.graphviz
  ];
}
