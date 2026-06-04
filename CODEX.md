# CODEX — carna-scis Local Coding Rules

Status: `promoted_instruction_file`
Owner: `Scanner Lane`
Phase: `55`
Runtime status: `inactive_by_default`
Repository role: `scanner_source_code`

## Purpose

Define local coding-agent rules for `carna-scis`.

These rules authorize safe documentation and source review work only. They do not authorize scanner execution on private data, package installation, workflows, release changes, deployment or external network behavior.

## Local-first Rule

```yaml
local_first:
  inspect_before_edit: true
  preserve_existing_structure: true
  avoid_unrelated_changes: true
  no_direct_main_write: true
  no_force_push: true
  no_history_rewrite: true
```

## Command Policy

```yaml
command_policy:
  destructive_commands_allowed: false
  package_install_allowed_without_review: false
  network_commands_allowed_without_review: false
  scanner_execution_on_private_data_allowed: false
  secret_scanning_before_commit_required: true
```

## File Policy

```yaml
file_policy:
  allowed:
    - markdown_documentation
    - Zig_source_review
    - local_scanner_docs
    - redacted_test_notes
  forbidden:
    - real_env_files
    - credentials
    - raw_private_exports
    - private_logs
    - browser_sessions
    - database_dumps
    - generated_secret_reports
```

## Output Policy

Every change must report:

```yaml
required_report:
  - files_changed
  - scope_confirmed
  - runtime_status
  - scanner_execution_status
  - secret_status
  - next_phase_or_blocker
```
