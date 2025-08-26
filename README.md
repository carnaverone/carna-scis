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
