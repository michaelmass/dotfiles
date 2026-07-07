# Agent Instructions

## Adding a dotfile

This repository is managed by `rotz`. Each tool or app gets its own top-level directory, and the directory contains a `dot.yaml` file describing how to install it and which files to link.

To add a new dotfile:

1. Create a top-level directory named after the command/app, for example `herdr/`.
2. Add `herdr/dot.yaml`.
3. Use the existing platform grouping style:
   - `windows:` for Windows setup.
   - `linux|darwin:` for Linux and macOS setup.
4. Add an `installs` entry:
   - Use a string for a single command.
   - Use `false` when there is nothing to install.
   - Use `{ cmd, depends }` when the install command requires another managed tool.
5. Add `links` only when the dotfile includes config files to symlink.
6. Keep paths relative on the left side of `links`, and use the destination path on the right side.
7. Follow the package manager convention already used in nearby files:
   - Homebrew for most `linux|darwin` CLI/app installs.
   - Scoop for Windows CLI installs.
   - `cargo install <crate>` for Rust crates.
   - `pnpm add -g <package> --config.node-linker=hoisted` for global npm packages that depend on pnpm.

Minimal install-only example:

```yaml
windows:
  installs: scoop install example-tool

linux|darwin:
  installs: brew install example-tool
```

Example with linked config files:

```yaml
windows:
  installs: scoop install example-tool
  links:
    config.toml: ~/.config/example-tool/config.toml

linux|darwin:
  installs: brew install example-tool
  links:
    config.toml: ~/.config/example-tool/config.toml
```

Before finishing, run dry-run validation when appropriate:

```bash
rotz --dry-run install
rotz --dry-run link
```
