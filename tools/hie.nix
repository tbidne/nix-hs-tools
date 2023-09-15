{ compiler
, nix-hs-utils
, pkgs
}:

nix-hs-utils.mkShellApp {
  inherit pkgs;
  name = "hie";
  text = ''
    set -e
    if [[ $1 == "--nh-help" ]]; then
      echo "usage: hie"
      exit 0
    fi
    ${compiler.implicit-hie}/bin/gen-hie > hie.yaml
  '';
  runtimeInputs = [ compiler.implicit-hie ];
}
