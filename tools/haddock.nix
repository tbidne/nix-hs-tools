{ pkgs }:

pkgs.writeShellScript "haddock.sh" ''
  args=()
  excluded=()
  threshold=100
  while [ $# -gt 0 ]; do
    if [[ $1 == "--nh-help" ]]; then
      echo "usage: nix run github:tbidne/nix-hs-tools#haddock -- [--threshold PERCENTAGE] [-x|--exclude MODULE] <args>"
      exit 0
    elif [[ $1 == "--exclude" || $1 == "-x" ]]; then
      excluded+=($2)
      shift
    elif [[ $1 == "--threshold" ]]; then
      threshold=$2
      shift
    else
      args+=($1)
    fi
    shift
  done

  metrics_string=$(cabal haddock ''${args[@]})
  if [[ $? -ne 0 ]]; then
    echo "Build failed!"
    exit 1
  fi

  readarray -t metrics <<<"$metrics_string"

  # This is extremely gross (thanks bash). Generally, lines look like:
  #   100% ( 2 / 2) in 'Module.Name'
  # and we are trying to capture the first number (percentage) and module name.
  regex="([0-9]{1,3})%[[:space:]]+\([[:space:]]*[0-9]+[[:space:]]*\/[[:space:]]*[0-9]+[[:space:]]*\)[[:space:]]+in[[:space:]]+'([a-zA-Z\.]+)'"

  any_failed=0
  ran_test=0
  for m in "''${metrics[@]}"; do
    if [[ $m =~ $regex ]]; then
      val="''${BASH_REMATCH[1]}"
      fn="''${BASH_REMATCH[2]}"

      # do not run on excluded files
      if [[ " ''${excluded[*]} " =~ " $fn " ]]; then
        echo "Skipping ''${fn}"
        continue
      fi

      if [[ $val -lt $threshold ]]; then
        echo "Haddock missing for $fn: $val"
        any_failed=1
      fi
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
''
