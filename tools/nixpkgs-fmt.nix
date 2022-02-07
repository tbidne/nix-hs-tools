{ pkgs }:

pkgs.writeShellScript "nixpkgs-fmt.sh" ''
  dir=.
  args=()
  while [ $# -gt 0 ]; do
    if [[ $1 == "--dir" ]]; then
      dir=$2
      shift 1
    else
      args+=($1)
    fi
    shift
  done
  ${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt -- $dir ''${args[@]}
''
