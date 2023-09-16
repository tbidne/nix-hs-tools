{ compiler
, nix-hs-utils
, pkgs
}:

nix-hs-utils.mkShellApp {
  inherit pkgs;
  name = "hlint";
  text = ''
    set -e
    args=()
    dir=.
    refact=0
    while [ $# -gt 0 ]; do
      if [[ $1 == "--nh-help" ]]; then
        echo "usage: hlint [--dir] [--refact] <args>"
        exit 0
      elif [[ $1 == "--dir" ]]; then
        dir=$2
        shift 1
      elif [[ $1 == "--refact" ]]; then
        refact=1
      else
        args+=("$1")
      fi
      shift
    done

    if [[ $refact == 0 ]]; then
      # shellcheck disable=SC2046
      ${compiler.hlint}/bin/hlint --ignore-glob=dist-newstyle --ignore-glob=stack-work "''${args[@]}" $(${pkgs.fd}/bin/fd "$dir" -e hs)
    else
      # refactor works on individual files only
      # shellcheck disable=SC2145
      ${pkgs.fd}/bin/fd "$dir" -e hs | ${pkgs.findutils}/bin/xargs -I % sh -c "
        ${compiler.hlint}/bin/hlint \
          --ignore-glob=dist-newstyle \
          --ignore-glob=stack-work \
          --refactor \
          --with-refactor ${compiler.apply-refact}/bin/refactor \
          --refactor-options=-i \
          ''${args[@]} %"
    fi
  '';
  runtimeInputs = [ compiler.apply-refact compiler.hlint pkgs.fd pkgs.findutils ];
}
