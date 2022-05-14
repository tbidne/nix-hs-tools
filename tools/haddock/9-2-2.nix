{ pkgs }:

import ./base.nix { ghcVersion = pkgs.haskell.packages.ghc922; }
