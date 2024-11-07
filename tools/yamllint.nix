{ nix-hs-utils, pkgs }:

nix-hs-utils.mkShellApp {
  inherit pkgs;
  name = "yamllint";
  text = ''
    set -e
    args=()
    dir=.
    while [ $# -gt 0 ]; do
      case "$1" in
        "--nh-help")
          echo "usage: yamllint [--dir PATH] <args>"
          exit 0
          ;;
        "--dir")
          dir=$2
          shift 1
          ;;
        *)
          args+=("$1")
          ;;
      esac
      shift
    done

    yamllint "''${args[@]}" "$dir"
  '';
  runtimeInputs = [ pkgs.yamllint ];
}
