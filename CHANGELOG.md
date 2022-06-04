# Revision history for nix-hs-tools

## 0.3 -- 2022-06-04

* Improved haddock.
  * Fixed bug where cabal build failure reported haddock success.
  * We now have a single tool that requires cabal and ghc to be user-provided.
* Add `help` and `version` "tools".
* Add `--nh-help` arg to each tool showing usage.
* Bump hlint to 3.4.
* Bump ormolu to 0.5.0.0.
* Bump fourmolu to 0.7.0.1.

## 0.2 -- 2022-05-14

* Added fourmolu
* Improved ignore haskell build paths
* GHC 9.2.1 -> GHC 9.2.2
* Simplify haddocks tool (no minor version)

## 0.1.0.0 -- 2022-02-06

* First version. Released on an unsuspecting world.
