# Security Policy

`carna-scis` is a local command-line utility for hashing, verification, random-data generation, hex conversion, and lightweight secret-pattern scanning.

## Security model

- Core operation is local and does not require telemetry or network access.
- Secret scanning is heuristic and can produce false positives or false negatives.
- Do not treat a clean scan as proof that a repository contains no secrets.
- Do not commit or submit real credentials, tokens, private keys, cookies, `.env` files, private logs, or unredacted findings as test fixtures or bug reports.
- Use synthetic values when reporting scanner behavior.

## Reporting a vulnerability

Do not open a public issue containing sensitive data. Use GitHub private vulnerability reporting when available, or contact the repository owner through the public GitHub profile/contact path.

A useful report should include the affected version or commit, minimal reproduction steps using synthetic data, expected behavior, observed behavior, and the security impact.

If a real credential is discovered, revoke or rotate it first, remove it from active content, and assess whether Git history also requires cleanup.
