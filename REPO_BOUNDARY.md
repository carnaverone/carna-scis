# Repository Boundary — carna-scis

Status: `promoted_instruction_file`
Owner: `Scanner Lane`
Phase: `55`
Runtime status: `inactive_by_default`
Repository role: `scanner_source_code`

## Repository Identity

```yaml
repository:
  name: carnaverone/carna-scis
  role: local_scanner_source_code
  source_of_truth_for:
    - Zig_scanner_source
    - hash_verify_rand_hex_tools
    - local_secret_pattern_detection
    - scanner_documentation
  not_source_of_truth_for:
    - Control_Tower_canon
    - Agent_Fleet_contracts
    - Cockpit_operator_UI
    - Export_Save_manifests
    - raw_private_exports
    - final_product_payloads
```

## Allowed Files

```yaml
allowed_file_families:
  - README.md
  - AGENTS.md
  - REPO_BOUNDARY.md
  - SECURITY.md
  - CODEX.md
  - LICENSE
  - src/**
  - build.zig
  - docs/**
```

## Forbidden Files

```yaml
forbidden_file_families:
  - .env
  - secrets/**
  - credentials/**
  - raw_exports/**
  - private_archives/**
  - private_logs/**
  - browser_sessions/**
  - database_dumps/**
```

## Cross-repo Rule

Scanner findings may be summarized as redacted reports. Raw private findings and secret values must not be committed.

## Stop Before Proceeding

```yaml
stop_before_proceeding_if:
  - file_contains_secret_or_token
  - file_contains_raw_private_export
  - change_adds_network_upload
  - change_adds_unreviewed_workflow
  - change_runs_scanner_on_private_material
```
