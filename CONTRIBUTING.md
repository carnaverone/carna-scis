# Contributing to carna-scis

Thank you for considering a contribution to `carna-scis`.

`carna-scis` is intended to stay small, portable, auditable, and useful as a single-binary Zig command-line tool.

## Project goals

- Keep the tool dependency-light and easy to build from source.
- Prefer clear, readable Zig code over clever abstractions.
- Maintain predictable command-line behavior.
- Keep security-related features honest: heuristics are not guarantees.
- Document user-facing changes in the README and changelog.

## Development setup

```bash
git clone https://github.com/carnaverone/carna-scis.git
cd carna-scis
zig build
zig build -Doptimize=ReleaseFast
zig build run -- --help
```

## Before submitting changes

Run the basic local checks:

```bash
zig fmt build.zig src/main.zig
zig build
zig build run -- --version
zig build run -- rand 32
zig build run -- hash LICENSE
```

When changing CLI behavior, also update:

- `README.md`
- `CHANGELOG.md` if present
- shell completions if the command surface changes
- man page if present

## Pull request style

Prefer small, focused pull requests:

- one feature or fix per PR;
- clear title;
- short explanation of the change;
- test command/output when relevant.

## Security-related changes

For features involving cryptography, secret scanning, or file integrity:

- avoid overstating guarantees;
- document limitations;
- prefer standard library primitives or well-reviewed algorithms;
- do not introduce network calls or telemetry without explicit discussion.

## License

By contributing, you agree that your contribution is released under the MIT license used by this repository.
