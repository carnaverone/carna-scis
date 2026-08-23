# carna-scis

**Zig CLI:** hash / verify / rand / hex / secrets — portable, single-binary.  
License: **MIT**.

> A minimal, practical command-line tool for everyday integrity checks, quick secret generation, hex conversions, and a lightweight secret-leak scan. Built in pure Zig, with no external runtime dependencies.

## Table of Contents
- [Features](#features)
- [Quick Start](#quick-start)
- [Installation](#installation)
  - [From prebuilt binaries](#from-prebuilt-binaries)
  - [Build from source](#build-from-source)
- [Usage](#usage)
  - [--help, --version](#--help---version)
  - [hash](#hash)
  - [verify](#verify)
  - [rand](#rand)
  - [hex enc / hex dec](#hex-enc--hex-dec)
  - [secrets scan](#secrets-scan)
- [Examples](#examples)
- [Completions](#completions)
- [Man Page](#man-page)
- [Exit Codes](#exit-codes)
- [Performance Notes & Limits](#performance-notes--limits)
- [Security Notes](#security-notes)
- [Roadmap](#roadmap)
- [Contributing](#contributing)
- [License](#license)

## Features
- **Hashing**: SHA-256 (default) or **SHA-512**
- **Verification**: file vs expected hex digest
- **Random secrets**: CSPRNG bytes in hex
- **Hex encode/decode**: file/stdin ↔ hex
- **Secret leak scan**: quick heuristics for common tokens (AWS/GitHub/Slack/Stripe/Google)

## Quick Start
```bash
zig build -Doptimize=ReleaseFast
./zig-out/bin/carna-scis --version
./zig-out/bin/carna-scis rand 32
./zig-out/bin/carna-scis hash LICENSE
./zig-out/bin/carna-scis verify LICENSE $(./zig-out/bin/carna-scis hash LICENSE)

Installation
From prebuilt binaries

sudo install -m755 carna-scis /usr/local/bin/carna-scis

Build from source

git clone https://github.com/carnaverone/carna-scis.git
cd carna-scis
zig build -Doptimize=ReleaseFast
sudo install -m755 zig-out/bin/carna-scis /usr/local/bin/carna-scis

Usage
--help / --version

carna-scis --help
carna-scis --version

hash

carna-scis hash <file> [--sha512]

verify

carna-scis verify <file> <digest_hex> [--sha512]

(exit code: 0 match, 1 mismatch)
rand

carna-scis rand [len]   # default 32 bytes

hex enc / hex dec

carna-scis hex enc <file|->
carna-scis hex dec <file|->

secrets scan

carna-scis secrets scan <path>

Examples

carna-scis rand 64 > .env.secret
carna-scis hash build.tar.gz --sha512
carna-scis verify build.tar.gz $(carna-scis hash build.tar.gz)
carna-scis hex enc logo.png > logo.hex && carna-scis hex dec logo.hex > logo.copy.png
carna-scis secrets scan ./src

Completions

sudo install -m644 completions/carna-scis.bash /etc/bash_completion.d/carna-scis
sudo install -m644 completions/_carna-scis /usr/share/zsh/site-functions/_carna-scis

Man Page

sudo install -m644 man/carna-scis.1 /usr/local/share/man/man1/carna-scis.1
sudo mandb || true
man carna-scis

Exit Codes

    0 success

    1 verify mismatch

    >1 other errors

Performance Notes & Limits

    secrets scan skips files > 2 MB

    hex ops read up to ~16 MB at once

Security Notes

Heuristics only; false positives/negatives are possible. For deep scans, consider trufflehog/gitleaks.
Roadmap

    encrypt/decrypt (ChaCha20-Poly1305 + PBKDF/Argon2)

    --json outputs

    directory Merkle hashing

    tests & fuzzing

Contributing

Small focused PRs welcome. Update README/completions/man for new commands.
License

MIT — see LICENSE.
