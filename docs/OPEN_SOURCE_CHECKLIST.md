# Open Source Readiness Checklist — carna-scis

Purpose: keep `carna-scis` clean, public, reusable, and safe to improve as an open-source CLI project.

## Repository baseline

- [x] Public repository
- [x] MIT license present
- [x] Zig source present
- [x] `build.zig` present
- [x] Security policy present
- [x] Contributing guide present
- [ ] README Markdown rendering fixed
- [ ] Changelog formalized
- [ ] Release workflow added
- [ ] CI build/test workflow added
- [ ] Tagged stable release created

## Code quality baseline

- [ ] `zig fmt` applied consistently
- [ ] `zig build` verified on Linux
- [ ] `zig build -Doptimize=ReleaseFast` verified
- [ ] Basic command smoke tests documented
- [ ] Exit codes documented and tested
- [ ] Large-file behavior reviewed
- [ ] Error messages normalized

## Security baseline

- [x] No network behavior required for core CLI
- [x] Local-first design
- [x] Security limitations documented
- [ ] Secret scan output masking reviewed
- [ ] Private data handling tested safely
- [ ] No test fixture contains real token material

## Suggested next technical patches

1. Fix README code fences and headings.
2. Add `.gitignore` for Zig build outputs.
3. Add `CHANGELOG.md` with version history.
4. Add simple GitHub Actions CI for `zig build`.
5. Add smoke-test script under `scripts/`.
6. Improve `secrets scan` to avoid allocator lifetime issues and reduce noisy output.
7. Add optional `--json` output for automation.
8. Add release artifacts once CI is stable.

## Nim track

Nim should remain optional unless the repository explicitly becomes a multi-language toolkit.

Recommended structure if Nim is added later:

```txt
nim/
  carna_scis_tools.nimble
  src/carna_scis_tools.nim
  README.md
```

Use Nim for helper tools, generators, packaging helpers, or fast scripts. Keep the Zig CLI as the primary product unless a separate Nim binary becomes justified.
