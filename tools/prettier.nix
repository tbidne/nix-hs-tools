{ nix-hs-utils, pkgs }:

nix-hs-utils.mkShellApp {
  inherit pkgs;
  name = "prettier";
  text = ''
    set -e
    args=()
    ext=""
    while [ $# -gt 0 ]; do
      case "$1" in
        "--nh-help")
          echo "usage: prettier [-y|--yaml] <args>"
          exit 0
          ;;
        "-y" | "--yaml")
          ext="**/*yaml"
          ;;
        *)
          args+=("$1")
          ;;
      esac
      shift
    done

    prettier "''${args[@]}" "$ext"
  '';
  runtimeInputs = [ pkgs.nodePackages.prettier ];
}
