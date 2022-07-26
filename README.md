<div align="center">

# nix-hs-tools

[![GitHub release (latest SemVer)](https://img.shields.io/github/v/tag/tbidne/nix-hs-tools?include_prereleases&sort=semver)](https://github.com/tbidne/nix-hs-tools/releases/)
[![nix](https://img.shields.io/github/workflow/status/tbidne/nix-hs-tools/nix/main?label=nix&logo=nixos&logoColor=85c5e7&labelColor=2f353c)](https://github.com/tbidne/nix-hs-tools/actions/workflows/nix_ci.yaml)
[![style](https://img.shields.io/github/workflow/status/tbidne/nix-hs-tools/style/main?label=style&logoColor=white&labelColor=2f353c)](https://github.com/tbidne/nix-hs-tools/actions/workflows/style_ci.yaml)
[![BSD-3-Clause](https://img.shields.io/github/license/tbidne/nix-hs-tools?color=blue)](https://opensource.org/licenses/BSD-3-Clause)

### Haskell development tools by Nix

</div>

---

- [Motivation](#motivation)
- [Introduction](#introduction)
- [Tools](#tools)
  - [Haskell Formatters](#haskell-formatters)
    - [Cabal-Fmt](#cabal-fmt)
    - [Fourmolu](#fourmolu)
    - [Ormolu](#ormolu)
    - [Stylish](#stylish)
  - [Haskell Linters](#haskell-linters)
    - [HLint](#hlint)
  - [Haskell Miscellaneous](#haskell-miscellaneous)
    - [Haddock Coverage](#haddock-coverage)
    - [HIE](#hie)
  - [Nix Formatters](#nix-formatters)
    - [Nixpkgs-Fmt](#nixpkgs-fmt)
  - [Information](#information)
    - [Help](#help)
    - [Version](#version)

# Motivation

Using nix, we provide a set of common tools for haskell development. In general, for a given tool, we provide two benefits over direct usage:

1. The tool itself i.e. no external dependencies required other than `nix`.
2. Common logic "on top" that is useful.

For example, for `ormolu`, not only do we provide the executable itself, we also run it recursively on all files in a given directory. The default behavior is for `ormolu` to run on files individually, so we judge this to be an ergonomic improvement.

We cannot always satisfy the first requirement. For example, the `haddock` tool requires `cabal` and `ghc` to be on the `$PATH` because we cannot hope to provide both in such a way that will work for an arbitrary project. In this case, the extra logic (i.e. `2`) is what is useful, so we consider this acceptable.

# Introduction

In the usage descriptions, `<args>` references tool-specific arguments that are passed-through. For example, in `ormolu`'s usage:

```
nix run github:tbidne/nix-hs-tools#ormolu -- [--dir PATH] <args>
```

`--dir` is specific to our nixified tool (see [ormolu](#ormolu) for details). All other arguments (e.g. `--mode check`) are ormolu-specific arguments that are passed to the ormolu executable.

Furthermore, each tool has a "help" page that is retrieved with `--nh-help`, showing the usage.

```
$ nix run github:tbidne/nix-hs-tools#ormolu -- --nh-help
usage: nix run github:tbidne/nix-hs-tools#ormolu -- [--dir PATH] <args>
```

The version can also be fixed e.g.

```
nix run github:tbidne/nix-hs-tools/0.4.0.1#<tool> -- <args>
```

# Tools

## Haskell Formatters

### Cabal-Fmt

**Source:** https://github.com/phadej/cabal-fmt

**Version:** 0.1.5.1

**Description:** The `cabal-fmt` formatter for `cabal` files. By default, searches the current directory for `*.cabal` files. Otherwise the search directory can be specified with `--dir DIR`.

**Usage:** `cabal-fmt [--dir PATH] <args>`.

**Examples:**

```
# runs the formatter on *.cabal files in the current directory
nix run github:tbidne/nix-hs-tools#cabal-fmt

# runs the formatter on *.cabal files in ../foo, and passes the --check flag
nix run github:tbidne/nix-hs-tools#cabal-fmt -- --dir ../foo --check
```

### Fourmolu

**Source:** https://github.com/fourmolu/fourmolu

**Version:** 0.7.0.1

**Description:** The `fourmolu` code formatter for haskell source files. Runs `fourmolu` recursively on all `hs` files in the specified directory, ignoring `dist-newstyle` and `.stack-work`. By default runs on the current directory, though it can be specified with `--dir`.

**Usage:** `fourmolu [--dir PATH] <args>`.

**Examples:**

```
# fails if any files in the current (recursive) path are not formatted.
nix run github:tbidne/nix-hs-tools#fourmolu -- --mode check

# formats all files in some-dir
nix run github:tbidne/nix-hs-tools#fourmolu -- --dir ../some-dir --mode inplace

# specifies extensions manually; does not use cabal file's default-extensions
nix run github:tbidne/nix-hs-tools#fourmolu -- --no-cabal --ghc-opt -XImportQualifiedPost --ghc-opt -XTypeApplications
```

### Ormolu

**Source:** https://github.com/tweag/ormolu

**Version:** 0.5.0.0

**Description:** The `ormolu` code formatter for haskell source files. Runs `ormolu` recursively on all `hs` files in the specified directory, ignoring `dist-newstyle` and `.stack-work`. By default runs on the current directory, though it can be specified with `--dir`.

**Usage:** `ormolu [--dir PATH] <args>`.

**Examples:**

```
# fails if any files in the current (recursive) path are not formatted.
nix run github:tbidne/nix-hs-tools#ormolu -- --mode check

# formats all files in some-dir
nix run github:tbidne/nix-hs-tools#ormolu -- --dir ../some-dir --mode inplace

# specifies extensions manually; does not use cabal file's default-extensions
nix run github:tbidne/nix-hs-tools#ormolu -- --no-cabal --ghc-opt -XImportQualifiedPost --ghc-opt -XTypeApplications
```

### Stylish

**Source:** https://github.com/haskell/stylish-haskell

**Version:** 0.14.2.0

**Description:** The `stylish-haskell` code formatter for haskell source files. Runs `stylish-haskell` recursively on all `hs` files in the specified directory, ignoring `dist-newstyle` and `.stack-work`. By default runs on the current directory, though it can be specified with `--dir`.

**Usage:** `stylish [--dir PATH] <args>`.

**Examples:**

```
# (recursively) formats all files in the current directory
nix run github:tbidne/nix-hs-tools#stylish -- --inplace
```

## Haskell Linters

### HLint

**Source:** https://github.com/ndmitchell/hlint

**Version:** 3.4

**Description:** The `hlint` linter. Runs recursively on the current directory, though this can be overridden with `--dir`. Ignores `dist-newstyle` and `stack-work`.

If the `--refact` option is given, runs recursively on all haskell files with the `--refactor` option and refactor flags `-i -s` i.e. in-place and prompts before each change. This behavior can be overridden by explicitly passing `--refactor-options`.

**Usage:** `hlint [--dir PATH] [--refact] <args>`.

**Examples:**

```
# recursively checks all files in the current directory
nix run github:tbidne/nix-hs-tools#hlint

# recursively applies suggestions to all files in the current directory, with a prompt.
nix run github:tbidne/nix-hs-tools#hlint -- --refact

# same as above but apply automatically, not in-place and no prompt.
nix run github:tbidne/nix-hs-tools#hlint -- --refact --refactor-options=""
```

## Haskell Miscellaneous

### Haddock Coverage

**Source:** https://haskell-haddock.readthedocs.io/en/latest/

**Version:** 0.1

**Description:** Tool for checking haddock coverage. Unlike the other tools that provide all dependencies, this tool requires `cabal` and `ghc` to be on the `$PATH` and the project to build with `cabal haddock`. In particular, if nix is used to provide dependencies, this command should be run inside the same nix shell.

**Usage:**

```
haddock-cov [-t|--threshold PERCENTAGE] [-x|--exclude MODULE]
            [-m|--module-threshold MODULE PERCENTAGE]
            [-v|--version] <args>
```

**Examples:**

```
# checks that all modules in the default package have 100% haddock coverage
nix run github:tbidne/nix-hs-tools#haddock-cov

# checks that all modules in the default package have 70% haddock coverage
nix run github:tbidne/nix-hs-tools#haddock-cov -- --threshold 70

# checks haddock coverage in all packages, excluding Data.Foo and Bar modules.
nix run github:tbidne/nix-hs-tools#haddock-cov -- --exclude Data.Foo -x Bar --haddock-all

# drops coverage for Data.Foo and Bar to 70 and 65, respectively.
nix run github:tbidne/nix-hs-tools#haddock-cov -- --module-threshold Data.Foo 70 -m Bar 65
```

### HIE

**Source:** https://github.com/Avi-D-coder/implicit-hie

**Version:** 0.1.2.7

**Description:** The `gen-hie` tool for generating an `hie` file. Redirects the output to `hie.yaml`.

**Usage:** `hie`.

**Examples:**

```
nix run github:tbidne/nix-hs-tools#hie
```

## Nix Formatters

### Nixpkgs-Fmt

**Source:** https://github.com/nix-community/nixpkgs-fmt

**Version:** 1.2.0

**Description:** The `nixpkgs-fmt` formatter. Recursively formats all `*.nix` files in the current directory or `--dir`.

**Usage:** `nixpkgs-fmt [--dir PATH] <args>`.

**Examples:**

```
nix run github:tbidne/nix-hs-tools#nixpkgs-fmt
```

# Information

## Help

**Description:** Returns a man page.

**Usage:** `help`.

## Version

**Description:** Returns the version.

**Usage:** `version`.