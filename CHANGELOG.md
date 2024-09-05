# Revision history for nix-hs-tools

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to the
[Haskell Package Versioning Policy](https://pvp.haskell.org/).

TODO: Check versions w/ final nixpkgs

## [0.11]
### Changed
* Updated tools:
  * `cabal-fmt: 0.1.11.0 -> 0.1.12`
  * `cabal-plan: 0.7.3.0 -> 0.7.4.0`
  * `fourmolu: 0.15.0.0 -> 0.16.2.0`
  * `hlint: 3.8 -> ???`
  * `nixfmt: 2024-03-01 -> 2024-08-16`
  * `ormolu: 0.7.4.0 -> 0.7.7.0`
  * `stylish: 0.14.6.0 -> ???`

### Added
* `aarch64` darwin and linux support.
* `prettier-3.2.5`
* `yamllint-1.35.1`

## [0.10] -- 2024-04-16
### Changed
* Updated tools:
  * `cabal-fmt: 0.1.7.0 -> 0.1.11.0`
  * `fourmolu: 0.13.1.0 -> 0.15.0.0`
  * `hlint: 3.6.1 -> 3.8`
  * `ormolu: 0.7.1.0 -> 0.7.4.0`
  * `stylish: 0.14.5.0 -> 0.14.6.0`
* `nixfmt` now points to `nixfmt-rfc-style`.

### Added
* Added `cabal-plan-0.7.3.0`

## [0.9.1.0] -- 2024-02-10
* Added `nixfmt-0.5.0`

## [0.9.0.1] -- 2023-09-26
* Fixed no args usage in `hie`.

## [0.9] -- 2023-09-16
### Remove
* Removed `haddock-cov`
### Changed
* Updated tools:
  * `cabal-fmt: 0.1.6 -> 0.1.7`
  * `fourmolu: 0.10.1.0 -> 0.13.1.0`
  * `hlint: 3.5 -> 3.6.1`
  * `implcit-hie: 0.1.2.7 -> 0.1.4.0`
  * `ormolu: 0.5.3.0 -> 0.7.1.0`
  * `stylish: 0.14.3.0 -> 0.14.5.0`

## [0.8] -- 2023-02-20
### Changed
* Updated tools:
  * `fourmolu: 0.8.2.0 -> 0.10.1.0`
  * `hlint: 3.4 -> 3.5`
  * `ormolu: 0.5.0.1 -> 0.5.3.0`
  * `stylish: 0.14.2.0 -> 0.14.3.0`

## [0.7] -- 2022-10-19
### Changed
* `hlint` with `--refact` now applies refactor hints automatically without
  prompts.
* Updated tools:
  * `cabal-fmt: 0.1.5.1 -> 0.1.6`
  * `fourmolu: 0.7.0.1 -> 0.8.2.0`
  * `nixpkgs-fmt: 1.2.0 -> 1.3.0`
  * `ormolu: 0.5.0.0 -> 0.5.0.1`

## [0.6.1] -- 2022-06-26
### Added
* Added `--module-threshold` arg to `haddock-cov` to set coverage per module.

### Fixed
* `haddock-cov` now parses module names with numbers.
* Improved usage descriptions.

## [0.6] -- 2022-06-21
### Changed
* Renamed haddock tool to haddock-cov to differentiate between it and the real
  haddock. This makes the version arg less confusion.

### Fixed
* Made versions on help page more robust.
* Fixed nix-hs-tools version.

## [0.5.1] -- 2022-06-17
### Added
* Added -t alias for haddock --threshold

## [0.5] -- 2022-06-16
### Changed
* Set all tools to fail on any error.

### Fixed
* Fixed cabal-fmt tool so that it skips build directory.

## [0.4.0.1] -- 2022-06-15
### Fixed
* Improved documentation / help.

## [0.4] -- 2022-06-14
### Added
* Added --refactor option to hlint.

### Fixed
* Now using cached fourmolo and hlint from nixpkgs.
* Improve reproducibility via getting find and xargs from nixpkgs.
* Documentation improvements.

## [0.3] -- 2022-06-04
### Changed
* Haddock is now a single tool that requires cabal and ghc to be user-provided.
* Bump hlint to 3.4.
* Bump ormolu to 0.5.0.0.
* Bump fourmolu to 0.7.0.1.

### Added
* Add `help` and `version` "tools".
* Add `--nh-help` arg to each tool showing usage.

### Fixed
* Fixed haddock bug where cabal build failure reported success.

## [0.2] -- 2022-05-14
### Changed
* GHC 9.2.1 -> GHC 9.2.2
* Simplify haddocks tool (no minor version)

### Added
* Added fourmolu

### Fixed
* Improved ignore haskell build paths

## [0.1.0.0] -- 2022-02-06

* First version. Released on an unsuspecting world.

[Unreleased]: https://github.com/tbidne/nix-hs-tools/compare/0.10...0.11
[0.10]: https://github.com/tbidne/nix-hs-tools/compare/0.9.1.0...0.10
[0.9.1.0]: https://github.com/tbidne/nix-hs-tools/compare/0.9.0.1...0.9.1.0
[0.9.0.1]: https://github.com/tbidne/nix-hs-tools/compare/0.9...0.9.0.1
[0.9]: https://github.com/tbidne/nix-hs-tools/compare/0.8...0.9
[0.8]: https://github.com/tbidne/nix-hs-tools/compare/0.7...0.8
[0.7]: https://github.com/tbidne/nix-hs-tools/compare/0.6.1...0.7
[0.6.1]: https://github.com/tbidne/nix-hs-tools/compare/0.6...0.6.1
[0.6]: https://github.com/tbidne/nix-hs-tools/compare/0.5.1..0.6
[0.5.1]: https://github.com/tbidne/nix-hs-tools/compare/0.5..0.5.1
[0.5]: https://github.com/tbidne/nix-hs-tools/compare/0.4.0.1..0.5
[0.4.0.1]: https://github.com/tbidne/nix-hs-tools/compare/0.4..0.4.0.1
[0.4]: https://github.com/tbidne/nix-hs-tools/compare/0.3..0.4
[0.3]: https://github.com/tbidne/nix-hs-tools/compare/0.2..0.3
[0.2]: https://github.com/tbidne/nix-hs-tools/compare/0.1..0.2
[0.1.0.0]: https://github.com/tbidne/nix-hs-tools/releases/tag/0.1.0.0
