# Changelog

All notable changes to this project will be documented in this file.

## [0.0.6] - 2026-05-28

### Added
- New primitive types: `:date`, `:time`, `:naive_datetime`, `:utc_datetime` (ISO 8601 parsing).
- Full-format parameter definition with a map: `cast_params id: %{type: :integer, required: true, default: 0}`.
- `default:` option — when a parameter is missing the default value is used instead of `nil` / instead of raising for non-required params.
- Custom type modules: any module exporting `cast/1` (`CastParams.Type` behaviour) can be used as a parameter type.
- `CHANGELOG.md`.
- GitHub Actions CI workflow covering Elixir 1.14–1.18 / OTP 25–27.

### Changed
- Minimum Elixir requirement bumped to `~> 1.15` (required by `phoenix ~> 1.7.22`, which is used in the test suite and pulled in via security advisory GHSA-628h-q48j-jr6q).
- `Plug` dependency bumped to `~> 1.14`.
- Test dependencies refreshed: `stream_data ~> 1.0`, `phoenix ~> 1.7`, `excoveralls ~> 0.18`, `ex_doc ~> 0.34`.
- Error messages from `CastParams.Plug` now print dotted parameter paths (e.g. `param user.name is required`).
- `cast_params` macro no longer leaves commented-out debug output behind.
- Hex package metadata: SPDX `MIT` license identifier, drop deprecated `contributors` field, include `CHANGELOG.md` in the published files.

### Removed
- `.travis.yml` (replaced by GitHub Actions).
- Outdated, dead-link CI/coverage badges in README.

### Fixed
- README example for the `create/2` action had an unbalanced brace.
- `route_helper.ex` no longer uses the deprecated `use Plug.Test`.

## [0.0.5] - 2025

- Added Credo analyzer and `mix validate` alias.
- Cleaned up README, dependency updates.
</content>
</invoke>