# nix-hs-tools

This repository contains a list of haskell development tools, provided by nix.

- [Tools](#tools)
  - [Haskell](#haskell)
    - [Formatters-HS](#formatters-hs)
      - [Cabal-Fmt](#cabal-fmt)
      - [Ormolu](#ormolu)
      - [Stylish](#stylish)
    - [Linters-HS](#linters-hs)
      - [HLint](#hlint)
    - [Miscellaneous-HS](#miscellaneous-hs)
      - [HIE](#hie)
  - [Nix](#nix)
    - [Formatters-Nix](#formatters-nix)
      - [Nixpkgs-Fmt](#nixpkgs-fmt)

# Tools

In the usage descriptions, `<args>` references tool-specific arguments that are passed-through. For example, in ormolu's usage:

```
# nix run github:tbidne/nix-hs-tools#ormolu -- [--dir PATH] [--no-cabal] <args>
```

`--dir` and `--no-cabal` are args specific to our nixified tool (see #ormolu for details). All other arguments (e.g. `--mode check`) are ormolu-specific arguments that are passed to the ormolu executable.

## Haskell

These are tools that specifically operate on haskell source/build files.

### Formatters-HS

#### Cabal-Fmt

**Source:** https://github.com/phadej/cabal-fmt

**Description:** The `cabal-fmt` formatter for `cabal` files. By default, searches the current directory for `*.cabal` files. Otherwise the search directory can be specified with `--dir DIR`.

**Usage:** `nix run github:tbidne/nix-hs-tools#cabal-fmt -- [--dir PATH] <args>`.

**Examples:**

```
# runs the formatter on *.cabal files in the current directory
nix run github:tbidne/nix-hs-tools#cabal-fmt

# runs the formatter on *.cabal files in ../foo, and passes the --check flag
nix run github:tbidne/nix-hs-tools#cabal-fmt -- --dir ../foo --check
```

#### Ormolu

**Source:** https://github.com/tweag/ormolu

**Description:** The `ormolu` code formatter for haskell source files. Runs `ormolu` recursively on all `hs` files in the specified directory, ignoring `dist-newstyle` and `.stack-work`. By default runs on the current directory, though it can be specified with `--dir`. Additionally, runs with the `--cabal-default-extensions` flag, though this can be disabled with `--no-cabal`.

**Usage:** `nix run github:tbidne/nix-hs-tools#ormolu -- [--dir PATH] [--no-cabal] <args>`.

**Examples:**

```
# fails if any files in the current (recursive) path are not formatted.
nix run github:tbidne/nix-hs-tools#ormolu -- --mode check

# formats all files in some-dir
nix run github:tbidne/nix-hs-tools#ormolu -- --dir ../some-dir --mode inplace

# specifies extensions manually; does not use cabal file's default-extensions
nix run github:tbidne/nix-hs-tools#ormolu -- --no-cabal --ghc-opt -XImportQualifiedPost --ghc-opt -XTypeApplications
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

### Linters-HS

#### HLint

**Source:** https://github.com/ndmitchell/hlint

**Description:** The `hlint` linter. Arguments are passed through.

**Usage:** `nix run github:tbidne/nix-hs-tools#hlint -- <args>`.

**Examples:**

```
nix run github:tbidne/nix-hs-tools#hlint -- .
```

### Miscellaneous-HS

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

### Formatters-Nix

#### Nixpkgs-Fmt

**Source:** https://github.com/nix-community/nixpkgs-fmt

**Description:** The `nixpkgs-fmt` formatter. Recursively formats all `*.nix` files in `./`.

**Usage:** `nix run github:tbidne/nix-hs-tools#nixpkgs-fmt`.

**Examples:**

```
nix run github:tbidne/nix-hs-tools#nixpkgs-fmt
```
