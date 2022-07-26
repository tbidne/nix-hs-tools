{ pkgs }:

let
  version = "0.1.1";
in
{
  inherit version;
  script = pkgs.writeShellScript "haddock-cov.sh" ''
    set -e
    args=()
    declare -A module_threshold
    excluded=()
    global_threshold=100
    while [ $# -gt 0 ]; do
      if [[ $1 == "--nh-help" ]]; then
        echo "usage: haddock-cov [-t|--threshold PERCENTAGE] [-x|--exclude MODULE]"
        echo "                   [-m|--module-threshold MODULE PERCENTAGE]"
        echo "                   [-v|--version] <args>"
        exit 0
      elif [[ $1 == "--exclude" || $1 == "-x" ]]; then
        excluded+=($2)
        shift
      elif [[ $1 == "--threshold" || $1 == "-t" ]]; then
        global_threshold=$2
        shift
      elif [[ $1 == "--module-threshold" || $1 == "-m" ]]; then
        module_threshold[$2]=$3
        shift 2
      elif [[ $1 == "--version" || $1 == "-v" ]]; then
        echo haddock-cov: ${version}
        exit 0
      else
        args+=($1)
      fi
      shift
    done

    metrics_string=$(cabal haddock ''${args[@]})

    readarray -t metrics <<<"$metrics_string"

    # This is extremely gross (thanks bash). Generally, lines look like:
    #   100% ( 2 / 2) in 'Module.Name'
    # and we are trying to capture the first number (percentage) and module name.
    regex="([0-9]{1,3})%[[:space:]]+\([[:space:]]*[0-9]+[[:space:]]*\/[[:space:]]*[0-9]+[[:space:]]*\)[[:space:]]+in[[:space:]]+'([a-zA-Z0-9\.]+)'"

    any_failed=0
    ran_test=0
    threshold=$global_threshold
    for m in "''${metrics[@]}"; do
      if [[ $m =~ $regex ]]; then
        val="''${BASH_REMATCH[1]}"
        fn="''${BASH_REMATCH[2]}"

        # do not run on excluded files
        if [[ " ''${excluded[*]} " =~ " $fn " ]]; then
          echo "Skipping ''${fn}"
          continue
        fi

        # set threshold if manually specified
        module_t=''${module_threshold[$fn]}
        if [[ -n $module_t ]]; then
          threshold=$module_t
        fi

        if [[ $val -lt $threshold ]]; then
          echo "Haddock missing for $fn: $val"
          any_failed=1
        fi

        # reset
        threshold=$global_threshold
      fi

      ran_test=1
    done

    if [ $ran_test == 0 ]; then
      echo "Did not run on any files!"
      exit 1
    elif [ $any_failed != 0 ]; then
      echo "Haddock failed!"
      exit 1
    else
      echo "Haddock passed!"
      exit 0
    fi
  '';
}
