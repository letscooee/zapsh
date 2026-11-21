# Changelog

All notable changes to zapsh are documented here. The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/)
and versions follow [Semantic Versioning](https://semver.org/).

## [Unreleased]

## [1.0.0] - 2026-11-21

First public release.

### Added

- Aliases for git, npm, Angular, NestJS, React Native, Android/adb, Cordova/Ionic, Firebase, Gradle, Grails, MongoDB,
  MySQL, nginx, Tomcat, AWS, IDEs, networking and everyday Linux/macOS use. Run `all` to list them.
- `zapsh` command: `zapsh version`, `zapsh update` and `zapsh uninstall`.
- One-line installer: `curl -fsSL https://raw.githubusercontent.com/letscooee/zapsh/main/install.sh | bash`.
- oh-my-zsh plugin entry point (`zapsh.plugin.zsh`), which also works with antidote and zinit.
- `bin/grails`, which picks the Grails version set in a project's `gradle.properties`.
- Helper scripts for git checkout, push/pull, tag deletion, MySQL dumps and React Native Android builds.

### Changed

- Repository layout uses `bin/` for commands on `PATH` and `libexec/` for helpers called by aliases.
- zapsh finds its own folder, so it works from any install location.
- `DB_BACKUP_DIRECTORY` can be overridden, and is created only when a dump runs.

### Fixed

- `all` no longer redefines the `export` and `function` builtins in zsh.
- Scripts no longer use `#!/usr/bin/env bash -e`, which fails on Linux.

[Unreleased]: https://github.com/letscooee/zapsh/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/letscooee/zapsh/releases/tag/v1.0.0
