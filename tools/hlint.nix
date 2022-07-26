{ find-hs-non-build
, pkgs
}:

pkgs.writeShellScript "hlint.sh" ''
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
      args+=($1)
    fi
    shift
  done

  if [[ $refact == 0 ]]; then
    ${pkgs.hlint}/bin/hlint --ignore-glob=dist-newstyle --ignore-glob=stack-work ''${args[@]} $dir
  else
    # refactor works on individual files only
    ${find-hs-non-build} | ${pkgs.findutils}/bin/xargs -I % sh -c "
      ${pkgs.hlint}/bin/hlint \
        --ignore-glob=dist-newstyle \
        --ignore-glob=stack-work \
        --refactor \
        --with-refactor ${pkgs.apply-refact}/bin/refactor \
        --refactor-options=-is \
        ''${args[@]} %"
  fi
''
