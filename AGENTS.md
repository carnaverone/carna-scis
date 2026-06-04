# AGENTS — carna-scis Scanner Instructions

Status: `promoted_instruction_file`
Owner: `Scanner Lane`
Phase: `55`
Runtime status: `inactive_by_default`
Repository role: `scanner_source_code`

## Repository Role

`carnaverone/carna-scis` owns scanner/source tooling for hashing, verification, random data, hex encoding and local secret-pattern detection.

It does not own Control Tower canon, Agent Fleet contracts, Cockpit operator UI, raw exports, private archives or final product payloads.

## Allowed Work

```yaml
allowed_work:
  - scanner_source_maintenance
  - documentation_updates
  - safe_test_design
  - security_boundary_clarification
  - local_only_scanner_rules
  - build_notes_without_execution
```

## Forbidden Work

```yaml
forbidden_work:
  - storing_real_secrets
  - storing_raw_private_exports
  - adding_network_exfiltration
  - adding_external_service_dependency
  - workflow_creation_without_review
  - package_install_without_review
  - direct_main_write
  - force_push
  - history_rewrite
  - branch_deletion_without_explicit_review
```

## Scanner Policy

```yaml
scanner_policy:
  scanner_execution_in_phase_55: false
  local_only_design: true
  network_access_required: false
  raw_secret_output_allowed: false
  masked_output_required: true
```

## PR Policy

```yaml
git_policy:
  branch_required: true
  draft_PR_required: true
  compare_before_PR: true
  comments_and_reviews_check_required: true
  merge_with_expected_head_sha_required: true
  force_push_allowed: false
  history_rewrite_allowed: false
```

## Stop Conditions

```yaml
stop_conditions:
  - requested_action_runs_scanner_on_private_data
  - requested_action_stores_secret_or_raw_log
  - requested_action_adds_network_upload
  - requested_action_adds_unreviewed_workflow
  - requested_action_changes_release_or_deployment
```
