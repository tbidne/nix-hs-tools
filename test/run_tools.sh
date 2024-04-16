set +e

export LANG="C.UTF-8"

export tools="
   cabal-fmt
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
for tool in $tools; do
  echo "*** TESTING: $tool ***"

  run_tool $tool

  exit_code=$?
  if [[ $exit_code -ne 0 ]]; then
    echo -e "\n*** FAILED: $tool ***\n"
    failed_str+=" $tool"
    any_failed=1
  else
    echo -e "\n*** SUCCEEDED: $tool ***\n"
    succeeded_str+=" $tool"
  fi

done

echo $succeeded_str
echo $failed_str
exit $any_failed