set +e

export LANG="C.UTF-8"

curr_timestamp () {
  date '+%s'
}

export tools="
   cabal-fmt
   cabal-plan
   fourmolu
   hie
   hlint
   nixfmt
   nixpkgs-fmt
   ormolu
   stylish
   help
   version
   "

run_tool () {
  if [[ $1 == "nixpkgs-fmt" ]]; then
    # nixpkgs-fmt --help exits with 1
    cmd_str="nix run .#nixpkgs-fmt"
  elif [[ $1 == "help" ]]; then
    cmd_str="nix run .#help"
  elif [[ $1 == "version" ]]; then
    cmd_str="nix run .#version"
  else
    cmd_str="nix run .#$1 -- --help"
  fi

  echo -e "\n*** RUNNING: $cmd_str ***\n"

  $cmd_str
}

succeeded_str="SUCCEEDED:"
failed_str="FAILED:"
any_failed=0

global_start_ts=$(curr_timestamp)

for tool in $tools; do
  echo "*** TESTING: $tool ***"

  start_ts=$(curr_timestamp)

  run_tool $tool
  exit_code=$?

  end_ts=$(curr_timestamp)

  diff_sec=$(( $end_ts - $start_ts ))

  if [[ $exit_code -ne 0 ]]; then
    echo -e "\n*** FAILED: $tool ($diff_sec seconds) ***\n"
    failed_str+=" $tool"
    any_failed=1
  else
    echo -e "\n*** SUCCEEDED: $tool ($diff_sec seconds) ***\n"
    succeeded_str+=" $tool"
  fi

done

global_end_ts=$(curr_timestamp)

global_diff_sec=$(( $global_end_ts - $global_start_ts ))

echo $succeeded_str
echo $failed_str

echo "TIME: $global_diff_sec seconds"

exit $any_failed
