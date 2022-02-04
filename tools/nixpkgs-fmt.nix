{ pkgs }:

pkgs.writeShellScript "nixpkgs-fmt.sh" ''
  ${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt -- ./ ''${@:1}
''
