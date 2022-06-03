<div align="center">

# Nix-HS-Tools

[![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/tbidne/nix-hs-tools?include_prereleases&sort=semver)](https://github.com/tbidne/nix-hs-tools/releases/)
[![nix](https://img.shields.io/github/workflow/status/tbidne/nix-hs-tools/nix/main?label=nix&logo=nixos&logoColor=85c5e7&labelColor=2f353c)](https://github.com/tbidne/nix-hs-tools/actions/workflows/nix_ci.yaml)
[![style](https://img.shields.io/github/workflow/status/tbidne/nix-hs-tools/style/main?label=style&logoColor=white&labelColor=2f353c)](https://github.com/tbidne/nix-hs-tools/actions/workflows/style_ci.yaml)
[![BSD-3-Clause](https://img.shields.io/github/license/tbidne/nix-hs-tools?color=blue)](https://opensource.org/licenses/BSD-3-Clause)

### Haskell development tools, by Nix.

</div>

---

- [Motivation](#motivation)
- [Introduction](#introduction)
- [Tools](#tools)
  - [Haskell](#haskell)
    - [Formatters-HS](#formatters-hs)
      - [Cabal-Fmt](#cabal-fmt)
      - [Ormolu](#ormolu)
      - [Stylish](#stylish)
    - [Linters-HS](#linters-hs)
      - [HLint](#hlint)
    - [Miscellaneous-HS](#miscellaneous-hs)
      - [Haddock](#haddock)
      - [HIE](#hie)
  - [Nix](#nix)
    - [Formatters-Nix](#formatters-nix)
      - [Nixpkgs-Fmt](#nixpkgs-fmt)
  - [Information](#information)
    - [Help](#help)
    - [Version](#version)

# Motivation

In general, for a given tool, we provide two benefits over using the tool directly:

1. The tool itself i.e. no external dependencies required other than `nix`.
2. Common logic "on top" that is useful.

For example, for `ormolu`, not only do we provide the executable itself, we also run it recursively on all files in a given directory. The default behavior is for `ormolu` to run on files individually, so we judge this to be an ergonomic improvement.

We cannot always satisfy the first requirement. For example, the `haddock` tool requires `cabal` and `ghc` to be on the `$PATH` because we cannot hope to provide both in such a way that will work for an arbitrary project. In this case, the extra logic (i.e. `2`) is what is useful, so we consider this acceptable.

# Introduction

In the usage descriptions, `<args>` references tool-specific arguments that are passed-through. For example, in `ormolu`'s usage:

```
nix run github:tbidne/nix-hs-tools#ormolu -- [--dir PATH] [--no-cabal] <args>
```

`--dir` and `--no-cabal` are args specific to our nixified tool (see [ormolu](#ormolu) for details). All other arguments (e.g. `--mode check`) are ormolu-specific arguments that are passed to the ormolu executable.

Furthermore, each tool has a "help" page that is retrieved with `--nh-help`, showing the usage.

```
$ nix run github:tbidne/nix-hs-tools#ormolu -- --nh-help
usage: nix run github:tbidne/nix-hs-tools#ormolu -- [--dir PATH] [--no-cabal] <args>
```

The version can also be fixed e.g.

```
nix run github:tbidne/nix-hs-tools/0.3#<tool> -- <args>
```

# Tools

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

#### Fourmolu

**Source:** https://github.com/fourmolu/fourmolu

**Description:** The `fourmolu` code formatter for haskell source files. Runs `fourmolu` recursively on all `hs` files in the specified directory, ignoring `dist-newstyle` and `.stack-work`. By default runs on the current directory, though it can be specified with `--dir`. Additionally, runs with the `--cabal-default-extensions` flag, though this can be disabled with `--no-cabal`.

**Usage:** `nix run github:tbidne/nix-hs-tools#fourmolu -- [--dir PATH] [--no-cabal] <args>`.

**Examples:**

```
# fails if any files in the current (recursive) path are not formatted.
nix run github:tbidne/nix-hs-tools#fourmolu -- --mode check

# formats all files in some-dir
nix run github:tbidne/nix-hs-tools#fourmolu -- --dir ../some-dir --mode inplace

# specifies extensions manually; does not use cabal file's default-extensions
nix run github:tbidne/nix-hs-tools#fourmolu -- --no-cabal --ghc-opt -XImportQualifiedPost --ghc-opt -XTypeApplications
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

**Description:** The `stylish-haskell` code formatter for haskell source files. Runs `stylish-haskell` recursively on all `hs` files in the specified directory, ignoring `dist-newstyle` and `.stack-work`. By default runs on the current directory, though it can be specified with `--dir`.

**Usage:** `nix run github:tbidne/nix-hs-tools#stylish -- [--dir PATH] <args>`.

**Examples:**

```
# (recursively) formats all files in the current directory
nix run github:tbidne/nix-hs-tools#stylish -- --inplace
```

### Linters-HS

#### HLint

**Source:** https://github.com/ndmitchell/hlint

**Description:** The `hlint` linter. Runs recursively on the current directory, though this can be overridden with `--dir`. Ignores `dist-newstyle` and `stack-work`.

**Usage:** `nix run github:tbidne/nix-hs-tools#hlint -- [--dir PATH] <args>`.

**Examples:**

```
nix run github:tbidne/nix-hs-tools#hlint -- .
```

### Miscellaneous-HS

#### Haddock

**Source:** https://haskell-haddock.readthedocs.io/en/latest/

**Description:** Tool for checking haddock coverage. Unlike the other tools that provide all dependencies, this tool requires `cabal` and `ghc` to be on the `$PATH` and the project to build with `cabal haddock`. In particular, if nix is used to provide dependencies, this command should be run inside the same nix shell.

**Usage:** `nix run github:tbidne/nix-hs-tools#haddock -- [--threshold PERCENTAGE] [-x|--exclude MODULE] <args>`.

**Examples:**

```
# checks that all modules in the default package have 100% haddock coverage
nix run github:tbidne/nix-hs-tools#haddock

# checks that all modules in the default package have 70% haddock coverage
nix run github:tbidne/nix-hs-tools#haddock -- --threshold 70

# checks haddock coverage in all packages, excluding Data.Foo and Bar modules.
nix run github:tbidne/nix-hs-tools#haddock -- --exclude Data.Foo -x Bar --haddock-all
```

#### HIE

**Source:** https://github.com/Avi-D-coder/implicit-hie

**Description:** The `gen-hie` tool for generating an `hie` file. Redirects the output to `hie.yaml`.

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

**Description:** The `nixpkgs-fmt` formatter. Recursively formats all `*.nix` files in the current directory or `--dir`.

**Usage:** `nix run github:tbidne/nix-hs-tools#nixpkgs-fmt -- [--dir PATH] <args>`.

**Examples:**

```
nix run github:tbidne/nix-hs-tools#nixpkgs-fmt
```

## Information

These are information "tools".

### Help

**Description:** Returns a man page.

**Usage:** `nix run github:tbidne/nix-hs-tools#help`.

### Version

**Description:** Returns the version.

**Usage:** `nix run github:tbidne/nix-hs-tools#version`.