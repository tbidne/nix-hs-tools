{ pkgs }:

import ./base.nix { ghcVersion = pkgs.haskell.packages.ghc8107; }
