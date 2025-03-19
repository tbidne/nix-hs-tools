<div align="center">

# nix-hs-tools

[![GitHub release (latest SemVer)](https://img.shields.io/github/v/tag/tbidne/nix-hs-tools?include_prereleases&sort=semver)](https://github.com/tbidne/nix-hs-tools/releases/)
![haskell](https://img.shields.io/static/v1?label=&message=9.10&logo=haskell&logoColor=655889&labelColor=2f353e&color=655889)
[![ci](http://img.shields.io/github/actions/workflow/status/tbidne/nix-hs-tools/ci.yaml?branch=main&logoColor=85c5e7&labelColor=2f353c)](https://github.com/tbidne/nix-hs-tools/actions/workflows/ci.yaml)
[![MIT](https://img.shields.io/github/license/tbidne/nix-hs-tools?color=blue)](https://opensource.org/licenses/MIT)

### Haskell development tools by Nix

</div>

---

<div align="center">

TODO: Check versions w/ final nixpkgs

###### Haskell Formatters
[![Static Badge](https://img.shields.io/badge/cabal--fmt-0.1.12-orange)](#cabal-fmt)
[![Static Badge](https://img.shields.io/badge/fourmolu-0.16.2.0-orange)](#fourmolu)
[![Static Badge](https://img.shields.io/badge/ormolu-0.7.7.0-orange)](#ormolu)
[![Static Badge](https://img.shields.io/badge/stylish-0.14.6.0-orange)](#stylish)

###### Haskell Linters
[![Static Badge](https://img.shields.io/badge/hlint-3.8-orange)](#hlint)

###### Haskell Miscellaneous
[![Static Badge](https://img.shields.io/badge/cabal--plan-0.7.4.0-orange)](#cabal-plan)
[![Static Badge](https://img.shields.io/badge/hie-0.1.4.0-orange)](#hie)

###### Nix Formatters
[![Static Badge](https://img.shields.io/badge/nixfmt-unstable--2025--03--03-orange)](#nixfmt)
[![Static Badge](https://img.shields.io/badge/nixpkgs--fmt-1.3.0-orange)](#nixpkgs-fmt)

###### Other
[![Static Badge](https://img.shields.io/badge/prettier-3.5.2-orange)](#prettier)
[![Static Badge](https://img.shields.io/badge/yamllint-1.35.1-orange)](#yamllint)

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
    - [Cabal Plan](#cabal-plan)
    - [HIE](#hie)
  - [Nix Formatters](#nix-formatters)
    - [Nixfmt](#nixfmt)
    - [Nixpkgs-Fmt](#nixpkgs-fmt)
  - [Other](#other)
    - [Prettier](#prettier)
    - [Yamllint](#yamllint)
  - [Information](#information)
    - [Help](#help)
    - [Version](#version)

# Motivation

Using nix, we provide a set of common tools for haskell development. In general, for a given tool, we provide two benefits over direct usage:

1. The tool itself i.e. no external dependencies required other than `nix`.
2. Common logic "on top" that is useful.

For example, for `ormolu`, not only do we provide the executable itself, we also run it recursively on all files in a given directory. The default behavior is for `ormolu` to run on files individually, so we judge this to be an ergonomic improvement.

## Alternatives

While `nix-hs-tools` is useful in a pinch, we sometimes want more granularity, e.g. pinning a project to a tool's specific version, or loading a general development shell. For these use-cases, see:

- Haskell flake utils: https://github.com/tbidne/nix-hs-utils
- Haskell development shells: https://github.com/tbidne/nix-hs-shells

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
nix run github:tbidne/nix-hs-tools/0.9.0.1#<tool> -- <args>
```

# Tools

## Haskell Formatters

### Cabal-Fmt

**Source:** https://github.com/phadej/cabal-fmt

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

**Description:** The `hlint` linter. Runs recursively on the current directory, though this can be overridden with `--dir`. Ignores `dist-newstyle` and `stack-work`.

If the `--refact` option is given, runs recursively on all haskell files with the `--refactor` option and refactor flag `-i` i.e. in-place. This behavior can be overridden by explicitly passing `--refactor-options`.

**Usage:** `hlint [--dir PATH] [--refact] <args>`.

**Examples:**

```
# recursively checks all files in the current directory
nix run github:tbidne/nix-hs-tools#hlint

# recursively applies suggestions to all files in the current directory, in-place.
nix run github:tbidne/nix-hs-tools#hlint -- --refact

# same as above but prompts before each change.
nix run github:tbidne/nix-hs-tools#hlint -- --refact --refactor-options="-is"

# not in-place and no prompt.
nix run github:tbidne/nix-hs-tools#hlint -- --refact --refactor-options=""
```

## Haskell Miscellaneous

### Cabal Plan

**Source:** https://github.com/haskell-hvr/cabal-plan/

**Description:** The `cabal-plan` tool.

**Usage:** `cabal-plan`.

**Examples:**

```
nix run github:tbidne/nix-hs-tools#cabal-plan
```

### HIE

**Source:** https://github.com/Avi-D-coder/implicit-hie

**Description:** The `gen-hie` tool for generating an `hie` file. Redirects the output to `hie.yaml`.

**Usage:** `hie`.

**Examples:**

```
nix run github:tbidne/nix-hs-tools#hie
```

## Nix Formatters

### Nixfmt

**Source:** https://github.com/NixOS/nixfmt

**Description:** The `nixfmt` formatter. Recursively formats all `*.nix` files in the current directory or `--dir`.

**Usage:** `nixfmt [--dir PATH] <args>`.

**Examples:**

```
nix run github:tbidne/nix-hs-tools#nixpkgs-fmt
```

### Nixpkgs-Fmt

**Source:** https://github.com/nix-community/nixpkgs-fmt

**Description:** The `nixpkgs-fmt` formatter. Recursively formats all `*.nix` files in the current directory or `--dir`.

**Usage:** `nixpkgs-fmt [--dir PATH] <args>`.

**Examples:**

```
nix run github:tbidne/nix-hs-tools#nixpkgs-fmt
```

## Other

### Prettier

**Source:** https://github.com/prettier/prettier

**Description:** The `prettier` formatter.

**Usage:** `prettier [-y|--yaml] <args>`.

**Examples:**

```
nix run github:tbidne/nix-hs-tools#prettier
```

### Yamllint

**Source:** https://github.com/adrienverge/yamllint

**Description:** The `yamllint` linter. Lints all `*.yaml` files in the current directory or `--dir`.

**Usage:** `yamllint [--dir PATH] <args>`.

**Examples:**

```
nix run github:tbidne/nix-hs-tools#yamllint
```

# Information

## Help

**Description:** Returns a man page.

**Usage:** `help`.

## Version

**Description:** Returns the version.

**Usage:** `version`.
