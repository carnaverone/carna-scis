# Security — carna-scis

Status: `promoted_instruction_file`
Owner: `Scanner Lane`
Phase: `55`
Runtime status: `inactive_by_default`
Repository role: `scanner_source_code`

## Security Scope

This repository contains local scanner source code and documentation.

It must not contain real secrets, raw private exports, private logs, private archives, browser sessions, database dumps or unredacted scan findings.

## Secret Policy

```yaml
secret_policy:
  real_secrets_allowed: false
  API_keys_allowed: false
  OAuth_tokens_allowed: false
  passwords_allowed: false
  private_keys_allowed: false
  browser_cookies_allowed: false
  raw_env_files_allowed: false
  placeholder_values_allowed: true
  masked_examples_allowed: true
```

## Scanner Output Policy

```yaml
scanner_output_policy:
  raw_secret_output_allowed: false
  masked_output_required: true
  private_scan_logs_allowed: false
  redacted_summary_allowed: true
```

## Runtime Policy

```yaml
runtime_policy:
  scanner_execution_in_phase_55: false
  workflow_added: false
  external_service_added: false
  network_upload_added: false
  package_install_added: false
```

## Review Gates

```yaml
review_gates:
  before_scanner_execution_on_private_data:
    - authorization_review
    - data_scope_review
    - output_redaction_review
    - explicit_human_review

  before_workflow_or_release_change:
    - CI_scope_review
    - secret_policy_review
    - rollback_policy
    - explicit_human_review
```

## Incident Rule

If a real secret or private payload is detected in repository content, stop immediately. Do not copy it, do not expand it, do not move it to another file. Record only a redacted finding and require manual remediation.
