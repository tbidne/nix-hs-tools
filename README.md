# nix-hs-tools

This repository contains a list of haskell development tools, provided by nix.

# Tools

## Haskell

These are tools that specifically operate on haskell source/build files.

### Formatters

#### Cabal-Fmt

**Source:** https://github.com/phadej/cabal-fmt

**Description:** The `cabal-fmt` formatter for `cabal` files.

**Usage:** `nix run github:tbidne/nix-hs-tools#cabal-fmt -- <args>`.

**Examples:**

```
# fails if any files in the current (recursive) path are not formatted.
nix run github:tbidne/nix-hs-tools#cabal-fmt -- some-project.cabal
```

#### Ormolu

**Source:** https://github.com/tweag/ormolu

**Description:** The `ormolu` code formatter for haskell source files. Runs `ormolu` recursively on all `hs` files in the parameter directory, ignoring `dist-newstyle` and `.stack-work`.

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

#### Stylish

**Source:** https://github.com/haskell/stylish-haskell

**Description:** The `stylish-haskell` code formatter for haskell source files. Because stylish has built-in support for running recursively on a directory (via the `--recursive` flag), there is no extra functionality. The executable is provided as-is.

**Usage:** `nix run github:tbidne/nix-hs-tools#stylish -- <args>`.

**Examples:**

```
# fails if any files in the current (recursive) path are not formatted.
nix run github:tbidne/nix-hs-tools#stylish-- --recursive ./src
```

### Linters

#### HLint

**Source:** https://github.com/ndmitchell/hlint

**Description:** The `hlint` linter. Arguments are passed through.

**Usage:** `nix run github:tbidne/nix-hs-tools#hlint -- <args>`.

**Examples:**

```
nix run github:tbidne/nix-hs-tools#hlint -- .
```

### Miscellaneous

#### HIE

**Source:** https://github.com/Avi-D-coder/implicit-hie

**Description:** The `gen-hie` linter. Redirects the output to `hie.yaml`.

**Usage:** `nix run github:tbidne/nix-hs-tools#hie`.

**Examples:**

```
nix run github:tbidne/nix-hs-tools#hie
```

## Nix

These are nix tools that are not directly related to haskell development, but are nontheless useful for haskell+nix development.

### Formatters

#### Nixpkgs-Fmt

**Source:** https://github.com/nix-community/nixpkgs-fmt

**Description:** The `nixpkgs-fmt` formatter. Recursively formats all `*.nix` files in `./`.

**Usage:** `nix run github:tbidne/nix-hs-tools#nixpkgs-fmt`.

**Examples:**

```
nix run github:tbidne/nix-hs-tools#nixpkgs-fmt
```
