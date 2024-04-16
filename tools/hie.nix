{ compiler, nix-hs-utils, pkgs }:

nix-hs-utils.mkShellApp {
  inherit pkgs;
  name = "hie";
  text = ''
    set -e
    if [[ $* == "--nh-help" ]]; then
      echo "usage: hie"
      exit 0
    elif [[ $* == "--help" ]]; then
      gen-hie --help
      exit 0
    fi
    gen-hie > hie.yaml
  '';
  runtimeInputs = [ compiler.implicit-hie ];
}
