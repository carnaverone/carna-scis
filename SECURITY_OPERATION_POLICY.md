# Security Operation Policy — carna-scis

Status: active policy.
Repository: `carnaverone/carna-scis`.
Visibility: public.
Tool role: security / integrity utility.

## Purpose

`carna-scis` is a public security and integrity utility for hashing, verification, random byte generation, hex conversion and lightweight secret-leak scanning.

Because this repository is public and security-adjacent, it must never contain real secrets, private scan outputs, private repository snapshots, raw credentials, private logs or unredacted findings.

## Current script inventory

```yaml
script_inventory:
  install_script_present: false
  scripts_directory_present: false
  shell_scripts_present: false
  executable_runtime_tool: true
  tool_language: zig
  public_repo: true
```

## Allowed

```yaml
allowed:
  - source_code_for_security_utility
  - non_secret_test_fixtures
  - documented_examples
  - public_build_instructions
  - redacted_scan_examples
  - safe_man_pages
  - safe_shell_completion_files
```

## Forbidden

```yaml
forbidden:
  - real_tokens
  - passwords
  - private_keys
  - browser_cookies
  - raw_env_files
  - private_scan_reports
  - raw_secret_findings
  - private_repository_snapshots
  - internal_project_exports
  - machine_specific_credentials
```

## Secret generation rule

The `rand` command may generate random bytes for local user use.

Generated secrets must not be committed back to this repository.

```yaml
secret_generation_policy:
  command_allowed: true
  generated_secret_commit_allowed: false
  examples_must_use_placeholders_or_local_paths: true
  examples_must_warn_against_committing_outputs: true
```

## Secret scan rule

The `secrets scan` command is a lightweight heuristic scanner.

```yaml
secret_scan_policy:
  heuristic_only: true
  false_positives_possible: true
  false_negatives_possible: true
  private_findings_must_not_be_committed: true
  unredacted_findings_allowed_in_public_repo: false
  deep_scan_tools_recommended_when_needed:
    - gitleaks
    - trufflehog
```

## Public repository boundary

Because this repo is public:

```yaml
public_boundary:
  commit_only_safe_examples: true
  redact_all_findings: true
  no_private_logs: true
  no_internal_exports: true
  no_real_environment_files: true
```

## Stop condition

Stop before merge if a change includes:

```yaml
stop_if:
  - real_secret_value
  - token_like_test_fixture_without_redaction
  - raw_scan_output
  - private_path_dump
  - .env_file
  - credentials_directory
  - browser_session_file
  - private_key_material
  - machine_specific_config
```

## Operating sentence

`carna-scis` may help detect or generate secrets locally. It must never store real secrets or unredacted findings.
