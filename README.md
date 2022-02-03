# nix-hs-tools

This repository contains a list of haskell development tools, provided by nix.

# Tools

## Ormolu

**Source:** https://github.com/tweag/ormolu

**Description:** The ormolu code formatter. Runs `ormolu` recursively on all `hs` files in the parameter directory, ignoring `dist-newstyle` and `.stack-work`.

**Usage:** `nix run github:tbidne/nix-hs-tools#ormolu -- <path> <args>`. Path is required; all other args are optional.

**Examples:**

```
# fails if any files in the current (recursive) path are not formatted.
nix run github:tbidne/nix-hs-tools#ormolu -- . --mode check

# formats all files in some-dir, passing in language extensions.
nix run github:tbidne/nix-hs-tools#ormolu -- ../some-dir --mode inplace --ghc-opt -XImportQualifiedPost --ghc-opt -XTypeApplications

# uses default-extensions from cabal file
nix run github:tbidne/nix-hs-tools#ormolu -- . --cabal-default-extensions
```
