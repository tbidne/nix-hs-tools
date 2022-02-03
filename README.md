# nix-hs-tools

This repository contains a list of haskell development tools, provided by nix.

# Tools

## Ormolu

**Source:** https://github.com/tweag/ormolu

**Description:** The ormolu code formatter. Runs `ormolu` recursively on all `hs` files in the current directory, ignoring `dist-newstyle` and `.stack-work`.

**Usage:** `nix run github:tbidne/nix-hs-tools#ormolu -- <path> <mode> <exts>`. Path and mode are both required, and up to 10 language extensions can be passed in.

**Examples:**

```
# fails if any files in the current (recursive) path are not formatted.
nix run github:tbidne/nix-hs-tools#ormolu -- . check

# formats all files in some-dir, passing in language extensions.
nix run github:tbidne/nix-hs-tools#ormolu -- ../some-dir inplace -XImportQualifiedPost -XTypeApplications
```
