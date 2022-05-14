{ pkgs }:

import ./base.nix { inherit pkgs; ghcVersion = "ghc902"; }
