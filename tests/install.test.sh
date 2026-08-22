#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
INSTALLER_PATH="$ROOT_DIR/install.sh"

# shellcheck source=/dev/null
source "$INSTALLER_PATH"

assert_eq() {
  local actual="$1"
  local expected="$2"
  local message="$3"

  if [[ "$actual" != "$expected" ]]; then
    printf '[FAIL] %s (actual=%s expected=%s)\n' "$message" "$actual" "$expected" >&2
    exit 1
  fi
}

assert_file_content() {
  local file_path="$1"
  local expected="$2"
  local message="$3"
  local actual=""

  actual="$(cat "$file_path")"
  assert_eq "$actual" "$expected" "$message"
}

assert_file_exists() {
  local file_path="$1"
  local message="$2"

  if [[ ! -f "$file_path" ]]; then
    printf '[FAIL] %s (missing=%s)\n' "$message" "$file_path" >&2
    exit 1
  fi
}

reset_installer_state() {
  TARGET_CLI=""
  OVERWRITE_POLICY="ask"
}

test_parse_args_explicit_values() {
  reset_installer_state
  parse_args copilot --overwrite yes

  assert_eq "$TARGET_CLI" "copilot" "parse_args should set explicit target"
  assert_eq "$OVERWRITE_POLICY" "yes" "parse_args should enable explicit overwrite"
}

test_parse_args_explicit_cursor_value() {
  reset_installer_state
  parse_args cursor --overwrite no

  assert_eq "$TARGET_CLI" "cursor" "parse_args should accept cursor as an explicit target"
  assert_eq "$OVERWRITE_POLICY" "no" "parse_args should preserve changed files when overwrite is disabled"
}

test_parse_args_explicit_grok_value() {
  reset_installer_state
  parse_args grok --overwrite yes

  assert_eq "$TARGET_CLI" "grok" "parse_args should accept grok as an explicit target"
  assert_eq "$OVERWRITE_POLICY" "yes" "parse_args should enable explicit overwrite for grok"
}

test_parse_args_defaults_target_when_missing() {
  reset_installer_state
  parse_args --overwrite yes

  assert_eq "$TARGET_CLI" "copilot" "parse_args should default target to copilot"
  assert_eq "$OVERWRITE_POLICY" "yes" "parse_args should parse overwrite policy without an explicit target"
}

test_parse_args_no_args_defaults() {
  reset_installer_state
  parse_args

  assert_eq "$TARGET_CLI" "copilot" "parse_args with no args should default target to copilot"
  assert_eq "$OVERWRITE_POLICY" "ask" "parse_args with no args should keep ask overwrite behavior"
}

test_parse_args_rejects_invalid_overwrite_value() {
  reset_installer_state

  if (parse_args --overwrite maybe 2>/dev/null); then
    printf '[FAIL] parse_args should reject invalid overwrite values\n' >&2
    exit 1
  fi
}

test_parse_args_rejects_missing_overwrite_value() {
  reset_installer_state

  if (parse_args --overwrite 2>/dev/null); then
    printf '[FAIL] parse_args should reject a missing overwrite value\n' >&2
    exit 1
  fi
}

test_parse_args_rejects_legacy_force_option() {
  reset_installer_state

  if (parse_args --force 2>/dev/null); then
    printf '[FAIL] parse_args should reject the legacy force option\n' >&2
    exit 1
  fi
}

test_parse_args_rejects_repo_ref_options() {
  if (parse_args --repo foo/bar 2>/dev/null); then
    printf '[FAIL] parse_args should reject --repo option\n' >&2
    exit 1
  fi

  if (parse_args --ref main 2>/dev/null); then
    printf '[FAIL] parse_args should reject --ref option\n' >&2
    exit 1
  fi
}

test_validate_target_rejects_unknown() {
  TARGET_CLI="unknown"
  if (validate_target 2>/dev/null); then
    printf '[FAIL] validate_target should reject unsupported targets\n' >&2
    exit 1
  fi
}

test_validate_target_accepts_cursor() {
  TARGET_CLI="cursor"
  validate_target
}

test_validate_target_accepts_grok() {
  TARGET_CLI="grok"
  validate_target
}

test_copy_asset_installs_and_sets_permissions() {
  local tmpdir=""
  local faketools=""
  local destination=""

  tmpdir="$(mktemp -d)"
  faketools="$tmpdir/faketools"
  mkdir -p "$faketools"

  cat >"$faketools/curl" <<'FAKECURL'
#!/usr/bin/env bash
set -euo pipefail
output_file=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    -o)
      output_file="$2"
      shift 2
      ;;
    *)
      shift
      ;;
  esac
done
printf 'fake-template-content' >"$output_file"
FAKECURL
  chmod +x "$faketools/curl"

  PATH="$faketools:$PATH"
  OVERWRITE_POLICY=yes

  destination="$tmpdir/output/file.txt"
  copy_asset "templates/test.txt" "$destination"

  assert_file_content "$destination" "fake-template-content" "copy_asset should install downloaded content"

  local mode=""
  mode="$(stat -c '%a' "$destination")"
  assert_eq "$mode" "644" "copy_asset should set 0644 permissions"
}

test_copy_asset_skips_when_unchanged() {
  local tmpdir=""
  local faketools=""
  local destination=""

  tmpdir="$(mktemp -d)"
  faketools="$tmpdir/faketools"
  mkdir -p "$faketools"

  cat >"$faketools/curl" <<'FAKECURL'
#!/usr/bin/env bash
set -euo pipefail
output_file=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    -o)
      output_file="$2"
      shift 2
      ;;
    *)
      shift
      ;;
  esac
done
printf 'same-content' >"$output_file"
FAKECURL
  chmod +x "$faketools/curl"

  PATH="$faketools:$PATH"
  OVERWRITE_POLICY=ask

  destination="$tmpdir/output/file.txt"
  mkdir -p "$(dirname "$destination")"
  printf 'same-content' >"$destination"

  if copy_asset "templates/test.txt" "$destination"; then
    printf '[FAIL] copy_asset should return non-zero when unchanged\n' >&2
    exit 1
  else
    local status="$?"
    assert_eq "$status" "2" "copy_asset should return 2 when destination is unchanged"
  fi
}

test_copy_asset_updates_changed_file_by_default() {
  local tmpdir=""
  local faketools=""
  local destination=""

  tmpdir="$(mktemp -d)"
  faketools="$tmpdir/faketools"
  mkdir -p "$faketools"

  cat >"$faketools/curl" <<'FAKECURL'
#!/usr/bin/env bash
set -euo pipefail
output_file=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    -o)
      output_file="$2"
      shift 2
      ;;
    *)
      shift
      ;;
  esac
done
printf 'updated-content' >"$output_file"
FAKECURL
  chmod +x "$faketools/curl"

  PATH="$faketools:$PATH"
  OVERWRITE_POLICY=ask

  destination="$tmpdir/output/file.txt"
  mkdir -p "$(dirname "$destination")"
  printf 'old-content' >"$destination"

  if ! (exec </dev/null; copy_asset "templates/test.txt" "$destination" >"$tmpdir/install.log"); then
    printf '[FAIL] copy_asset should update a changed managed file by default\n' >&2
    exit 1
  fi

  assert_file_content "$destination" "updated-content" "copy_asset should update changed managed files by default"
}

test_copy_asset_preserves_protected_decisions_file() {
  local tmpdir=""
  local faketools=""

  tmpdir="$(mktemp -d)"
  faketools="$tmpdir/faketools"
  mkdir -p "$faketools"

  cat >"$faketools/curl" <<'FAKECURL'
#!/usr/bin/env bash
set -euo pipefail
output_file=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    -o)
      output_file="$2"
      shift 2
      ;;
    *)
      shift
      ;;
  esac
done
printf 'new-decisions-content' >"$output_file"
FAKECURL
  chmod +x "$faketools/curl"

  PATH="$faketools:$PATH"
  OVERWRITE_POLICY=yes

  printf 'project-decisions-content' >"$tmpdir/DECISIONS.yml"

  pushd "$tmpdir" >/dev/null
  if copy_asset "templates/test.txt" "DECISIONS.yml"; then
    popd >/dev/null
    printf '[FAIL] copy_asset should preserve DECISIONS.yml even with overwrite enabled\n' >&2
    exit 1
  else
    local status="$?"
    popd >/dev/null
    assert_eq "$status" "1" "copy_asset should return 1 when DECISIONS.yml is protected"
  fi

  assert_file_content "$tmpdir/DECISIONS.yml" "project-decisions-content" "copy_asset should preserve project DECISIONS.yml content"
}

test_install_staged_asset_honors_no_policy() {
  local tmpdir=""
  local staged_file=""
  local destination=""

  tmpdir="$(mktemp -d)"
  staged_file="$tmpdir/staged.txt"
  destination="$tmpdir/output/file.txt"
  mkdir -p "$(dirname "$destination")"
  printf 'new-content' >"$staged_file"
  printf 'old-content' >"$destination"
  OVERWRITE_POLICY=no

  if install_staged_asset "$staged_file" "$destination" >"$tmpdir/install.log"; then
    printf '[FAIL] install_staged_asset should skip changed files when overwrite is disabled\n' >&2
    exit 1
  else
    local status="$?"
    assert_eq "$status" "1" "install_staged_asset should return 1 when overwrite is disabled"
  fi

  assert_file_content "$destination" "old-content" "overwrite=no should preserve changed managed files"
}

test_install_staged_asset_honors_yes_policy() {
  local tmpdir=""
  local staged_file=""
  local destination=""

  tmpdir="$(mktemp -d)"
  staged_file="$tmpdir/staged.txt"
  destination="$tmpdir/output/file.txt"
  mkdir -p "$(dirname "$destination")"
  printf 'new-content' >"$staged_file"
  printf 'old-content' >"$destination"
  OVERWRITE_POLICY=yes

  if ! install_staged_asset "$staged_file" "$destination" >"$tmpdir/install.log"; then
    printf '[FAIL] install_staged_asset should overwrite changed files when overwrite is enabled\n' >&2
    exit 1
  fi

  assert_file_content "$destination" "new-content" "overwrite=yes should update changed managed files"
}

run_confirm_overwrite_in_pty() {
  local answer="$1"

  if ! command -v script >/dev/null 2>&1; then
    printf '[INFO] skipping interactive confirmation test because script is unavailable\n'
    return 0
  fi

  printf '%s\n' "$answer" | DODKIT_INSTALLER_PATH="$INSTALLER_PATH" script -qec "bash -c 'source \"\$DODKIT_INSTALLER_PATH\"; if confirm_overwrite test; then echo accepted; else echo rejected; fi'" /dev/null 2>&1
}

test_confirm_overwrite_defaults_to_all_in_interactive_terminal() {
  local output=""

  output="$(run_overwrite_policy_sequence_in_pty "")"

  if [[ "$output" != *"Overwrite this file? [y/n/A] (A = all remaining files):"* ]] || [[ "$output" != *"first-accepted"* ]] || [[ "$output" != *"second-accepted"* ]] || [[ "$output" != *"policy=yes"* ]]; then
    printf '[FAIL] interactive overwrite confirmation should overwrite all remaining files after an empty response\n' >&2
    exit 1
  fi

  local prompt_count=""
  prompt_count="$(printf '%s' "$output" | grep -o 'Overwrite this file?' | wc -l | tr -d ' ')"
  assert_eq "$prompt_count" "1" "an empty response should prompt only once for all remaining files"
}

test_confirm_overwrite_skips_on_explicit_no_in_interactive_terminal() {
  local output=""

  output="$(run_confirm_overwrite_in_pty "n")"

  if [[ "$output" != *"Overwrite this file? [y/n/A] (A = all remaining files):"* ]] || [[ "$output" != *"rejected"* ]]; then
    printf '[FAIL] interactive overwrite confirmation should skip on an explicit no response\n' >&2
    exit 1
  fi
}

run_overwrite_policy_sequence_in_pty() {
  local answer="$1"

  if ! command -v script >/dev/null 2>&1; then
    printf '[INFO] skipping interactive all confirmation test because script is unavailable\n'
    return 0
  fi

  printf '%s\n' "$answer" | DODKIT_INSTALLER_PATH="$INSTALLER_PATH" script -qec "bash -c 'source \"\$DODKIT_INSTALLER_PATH\"; OVERWRITE_POLICY=ask; if should_overwrite first; then echo first-accepted; else echo first-rejected; fi; if should_overwrite second; then echo second-accepted; else echo second-rejected; fi; echo policy=\$OVERWRITE_POLICY'" /dev/null 2>&1
}

test_confirm_overwrite_all_switches_remaining_files_to_yes() {
  local output=""

  output="$(run_overwrite_policy_sequence_in_pty "a")"

  if [[ "$output" != *"Overwrite this file? [y/n/A] (A = all remaining files):"* ]] || [[ "$output" != *"first-accepted"* ]] || [[ "$output" != *"second-accepted"* ]] || [[ "$output" != *"policy=yes"* ]]; then
    printf '[FAIL] interactive all response should accept the current and subsequent files without another prompt\n' >&2
    exit 1
  fi

  local prompt_count=""
  prompt_count="$(printf '%s' "$output" | grep -o 'Overwrite this file?' | wc -l | tr -d ' ')"
  assert_eq "$prompt_count" "1" "interactive all response should prompt only once"
}

test_copy_asset_refuses_symlink_paths() {
  local tmpdir=""
  local faketools=""
  local destination=""
  local protected_file=""

  tmpdir="$(mktemp -d)"
  faketools="$tmpdir/faketools"
  mkdir -p "$faketools"

  cat >"$faketools/curl" <<'FAKECURL'
#!/usr/bin/env bash
set -euo pipefail
output_file=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    -o)
      output_file="$2"
      shift 2
      ;;
    *)
      shift
      ;;
  esac
done
printf 'downloaded-content' >"$output_file"
FAKECURL
  chmod +x "$faketools/curl"

  PATH="$faketools:$PATH"
  OVERWRITE_POLICY=yes

  mkdir -p "$tmpdir/real-output"
  ln -s "$tmpdir/real-output" "$tmpdir/output"

  if [[ ! -L "$tmpdir/output" ]]; then
    printf '[INFO] skipping symlink-path test because this bash environment does not create real symlinks\n'
    return 0
  fi

  destination="$tmpdir/output/file.txt"
  protected_file="$tmpdir/real-output/file.txt"
  printf 'protected-content' >"$protected_file"

  if copy_asset "templates/test.txt" "$destination"; then
    printf '[FAIL] copy_asset should refuse symlink paths\n' >&2
    exit 1
  else
    local status="$?"
    assert_eq "$status" "1" "copy_asset should return 1 when destination path uses a symlink"
  fi

  assert_file_content "$protected_file" "protected-content" "copy_asset should not overwrite through symlink paths"
}

assert_asset_specs_are_well_formed() {
  local target_name="$1"
  shift

  local asset_spec=""
  local source_path=""
  local destination_path=""
  local asset_name=""

  for asset_spec in "$@"; do
    IFS='|' read -r source_path destination_path asset_name <<< "$asset_spec"

    if [[ -z "$source_path" ]] || [[ -z "$destination_path" ]] || [[ -z "$asset_name" ]]; then
      printf '[FAIL] %s asset spec should contain source, destination, and asset name: %s\n' "$target_name" "$asset_spec" >&2
      exit 1
    fi
  done
}

test_asset_specs_are_well_formed() {
  assert_asset_specs_are_well_formed "copilot" "${COPILOT_ASSET_SPECS[@]}"
  assert_asset_specs_are_well_formed "cursor" "${CURSOR_ASSET_SPECS[@]}"
}

test_copilot_manifest_includes_discussion_record_template() {
  local found_source=0
  local found_destination=0
  local asset_spec=""
  local source_path=""
  local destination_path=""
  local asset_name=""

  for asset_spec in "${COPILOT_ASSET_SPECS[@]}"; do
    IFS='|' read -r source_path destination_path asset_name <<< "$asset_spec"

    if [[ "$source_path" == "templates/discussion-record.md" ]]; then
      found_source=1
      if [[ "$destination_path" == ".dodkit/templates/discussion-record.md" ]]; then
        found_destination=1
      fi
    fi
  done

  assert_eq "$found_source" "1" "copilot manifest should include templates/discussion-record.md"
  assert_eq "$found_destination" "1" "discussion-record template should map to .dodkit/templates/discussion-record.md"
}

test_copilot_manifest_includes_skill_templates() {
  local expected_sources=(
    "templates/skills/discussion.skill.md"
    "templates/skills/discussion-validation.skill.md"
    "templates/skills/decision-promotion.skill.md"
    "templates/skills/implementation.skill.md"
    "templates/skills/implementation-validation.skill.md"
  )

  local expected_destinations=(
    ".github/skills/discussion/SKILL.md"
    ".github/skills/discussion-validation/SKILL.md"
    ".github/skills/decision-promotion/SKILL.md"
    ".github/skills/implementation/SKILL.md"
    ".github/skills/implementation-validation/SKILL.md"
  )

  local index=0
  local asset_spec=""
  local source_path=""
  local destination_path=""
  local asset_name=""
  local found_match=0

  for index in "${!expected_sources[@]}"; do
    found_match=0
    for asset_spec in "${COPILOT_ASSET_SPECS[@]}"; do
      IFS='|' read -r source_path destination_path asset_name <<< "$asset_spec"

      if [[ "$source_path" == "${expected_sources[$index]}" ]] && [[ "$destination_path" == "${expected_destinations[$index]}" ]]; then
        found_match=1
        break
      fi
    done

    assert_eq "$found_match" "1" "copilot manifest should include ${expected_sources[$index]} -> ${expected_destinations[$index]}"
  done
}

test_cursor_manifest_includes_discussion_record_template() {
  local found_source=0
  local found_destination=0
  local asset_spec=""
  local source_path=""
  local destination_path=""
  local asset_name=""

  for asset_spec in "${CURSOR_ASSET_SPECS[@]}"; do
    IFS='|' read -r source_path destination_path asset_name <<< "$asset_spec"

    if [[ "$source_path" == "templates/discussion-record.md" ]]; then
      found_source=1
      if [[ "$destination_path" == ".dodkit/templates/discussion-record.md" ]]; then
        found_destination=1
      fi
    fi
  done

  assert_eq "$found_source" "1" "cursor manifest should include templates/discussion-record.md"
  assert_eq "$found_destination" "1" "cursor discussion-record template should map to .dodkit/templates/discussion-record.md"
}

test_cursor_manifest_includes_rule_templates() {
  local expected_sources=(
    "templates/agent.md"
    "templates/skills/discussion.skill.md"
    "templates/skills/discussion-validation.skill.md"
    "templates/skills/decision-promotion.skill.md"
    "templates/skills/implementation.skill.md"
    "templates/skills/implementation-validation.skill.md"
  )

  local expected_destinations=(
    ".cursor/rules/dod-implementation-agent.mdc"
    ".cursor/rules/discussion.mdc"
    ".cursor/rules/discussion-validation.mdc"
    ".cursor/rules/decision-promotion.mdc"
    ".cursor/rules/implementation.mdc"
    ".cursor/rules/implementation-validation.mdc"
  )

  local index=0
  local asset_spec=""
  local source_path=""
  local destination_path=""
  local asset_name=""
  local found_match=0

  for index in "${!expected_sources[@]}"; do
    found_match=0
    for asset_spec in "${CURSOR_ASSET_SPECS[@]}"; do
      IFS='|' read -r source_path destination_path asset_name <<< "$asset_spec"

      if [[ "$source_path" == "${expected_sources[$index]}" ]] && [[ "$destination_path" == "${expected_destinations[$index]}" ]]; then
        found_match=1
        break
      fi
    done

    assert_eq "$found_match" "1" "cursor manifest should include ${expected_sources[$index]} -> ${expected_destinations[$index]}"
  done
}

test_grok_manifest_includes_workspace_assets() {
  local expected_sources=(
    "templates/agent.md"
    "templates/DECISIONS.yml"
    "templates/discussion-record.md"
    "templates/skills/discussion.skill.md"
    "templates/skills/discussion-validation.skill.md"
    "templates/skills/decision-promotion.skill.md"
    "templates/skills/implementation.skill.md"
    "templates/skills/implementation-validation.skill.md"
  )

  local expected_destinations=(
    ".grok/dod.agent.md"
    "DECISIONS.yml"
    ".dodkit/templates/discussion-record.md"
    ".grok/discussion.skill.md"
    ".grok/discussion-validation.skill.md"
    ".grok/decision-promotion.skill.md"
    ".grok/implementation.skill.md"
    ".grok/implementation-validation.skill.md"
  )

  local index=0
  local asset_spec=""
  local source_path=""
  local destination_path=""
  local asset_name=""
  local found_match=0

  for index in "${!expected_sources[@]}"; do
    found_match=0
    for asset_spec in "${GROK_ASSET_SPECS[@]}"; do
      IFS='|' read -r source_path destination_path asset_name <<< "$asset_spec"

      if [[ "$source_path" == "${expected_sources[$index]}" ]] && [[ "$destination_path" == "${expected_destinations[$index]}" ]]; then
        found_match=1
        break
      fi
    done

    assert_eq "$found_match" "1" "grok manifest should include ${expected_sources[$index]} -> ${expected_destinations[$index]}"
  done
}

test_run_install_for_copilot_updates_managed_agent_and_preserves_decisions() {
  local tmpdir=""
  local faketools=""

  tmpdir="$(mktemp -d)"
  faketools="$tmpdir/faketools"
  mkdir -p "$faketools"

  cat >"$faketools/curl" <<'FAKECURL'
#!/usr/bin/env bash
set -euo pipefail
output_file=""
source_url=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    -o)
      output_file="$2"
      shift 2
      ;;
    *)
      source_url="$1"
      shift
      ;;
  esac
done

case "$source_url" in
  *"/templates/agent.md")
    printf 'updated-copilot-agent' >"$output_file"
    ;;
  *"/templates/DECISIONS.yml")
    printf 'new-decisions-template' >"$output_file"
    ;;
  *)
    printf 'copilot-source:%s' "$source_url" >"$output_file"
    ;;
esac
FAKECURL
  chmod +x "$faketools/curl"

  PATH="$faketools:$PATH"
  TARGET_CLI="copilot"
  OVERWRITE_POLICY=ask

  mkdir -p "$tmpdir/.github/agents"
  printf 'old-copilot-agent' >"$tmpdir/.github/agents/dod.agent.md"
  printf 'project-decisions-content' >"$tmpdir/DECISIONS.yml"

  pushd "$tmpdir" >/dev/null
  (exec </dev/null; run_install_for_target >"$tmpdir/install.log")
  popd >/dev/null

  assert_file_content "$tmpdir/.github/agents/dod.agent.md" "updated-copilot-agent" "copilot reinstall should update the managed agent by default"
  assert_file_content "$tmpdir/DECISIONS.yml" "project-decisions-content" "copilot reinstall should preserve project DECISIONS.yml"
}

test_run_install_for_cursor_creates_expected_workspace_files() {
  local tmpdir=""
  local faketools=""

  tmpdir="$(mktemp -d)"
  faketools="$tmpdir/faketools"
  mkdir -p "$faketools"

  cat >"$faketools/curl" <<'FAKECURL'
#!/usr/bin/env bash
set -euo pipefail
output_file=""
source_url=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    -o)
      output_file="$2"
      shift 2
      ;;
    *)
      source_url="$1"
      shift
      ;;
  esac
done

case "$source_url" in
  *"/templates/agent.md")
    cat >"$output_file" <<'EOF'
---
name: DOD Implementation Agent
description: Example
---

# Shared Agent Body
EOF
    ;;
  *"/templates/skills/discussion.skill.md")
    cat >"$output_file" <<'EOF'
---
name: discussion
description: Example
---

# Shared Discussion Body
EOF
    ;;
  *"/templates/discussion-record.md")
    printf 'shared-discussion-record-template' >"$output_file"
    ;;
  *"/templates/DECISIONS.yml")
    printf 'shared-decisions-template' >"$output_file"
    ;;
  *)
    printf 'generic-source:%s' "$source_url" >"$output_file"
    ;;
esac
FAKECURL
  chmod +x "$faketools/curl"

  PATH="$faketools:$PATH"
  TARGET_CLI="cursor"
  OVERWRITE_POLICY=yes

  pushd "$tmpdir" >/dev/null
  run_install_for_target
  popd >/dev/null

  assert_file_content "$tmpdir/.cursor/rules/dod-implementation-agent.mdc" "---
description: DOD main controller instructions for manual use in Cursor.
alwaysApply: false
---

# Shared Agent Body" "cursor target should render the main Cursor rule from the shared agent template"
  assert_file_content "$tmpdir/.cursor/rules/discussion.mdc" "---
description: DOD Gate A step 1 discussion procedure for manual use in Cursor.
alwaysApply: false
---

# Shared Discussion Body" "cursor target should render the discussion Cursor rule from the shared skill template"
  assert_file_content "$tmpdir/.dodkit/templates/discussion-record.md" "shared-discussion-record-template" "cursor target should still install the shared discussion record template without rendering"
}

test_run_install_for_grok_creates_expected_workspace_files() {
  local tmpdir=""
  local faketools=""

  tmpdir="$(mktemp -d)"
  faketools="$tmpdir/faketools"
  mkdir -p "$faketools"

  cat >"$faketools/curl" <<'FAKECURL'
#!/usr/bin/env bash
set -euo pipefail
output_file=""
source_url=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    -o)
      output_file="$2"
      shift 2
      ;;
    *)
      source_url="$1"
      shift
      ;;
  esac
done

case "$source_url" in
  *"/templates/agent.md")
    printf 'grok-agent-content' >"$output_file"
    ;;
  *"/templates/skills/discussion.skill.md")
    printf 'grok-discussion-skill-content' >"$output_file"
    ;;
  *"/templates/DECISIONS.yml")
    printf 'grok-decisions-template' >"$output_file"
    ;;
  *"/templates/discussion-record.md")
    printf 'grok-discussion-record-template' >"$output_file"
    ;;
  *)
    printf 'generic-grok-source:%s' "$source_url" >"$output_file"
    ;;
esac
FAKECURL
  chmod +x "$faketools/curl"

  PATH="$faketools:$PATH"
  TARGET_CLI="grok"
  OVERWRITE_POLICY=yes

  pushd "$tmpdir" >/dev/null
  run_install_for_target
  popd >/dev/null

  assert_file_content "$tmpdir/.grok/dod.agent.md" "grok-agent-content" "grok target should copy the shared agent source into .grok"
  assert_file_content "$tmpdir/.grok/discussion.skill.md" "grok-discussion-skill-content" "grok target should copy the discussion skill into .grok"
  assert_file_exists "$tmpdir/.grok/discussion-validation.skill.md" "grok target should install the discussion validation skill into .grok"
  assert_file_exists "$tmpdir/.grok/decision-promotion.skill.md" "grok target should install the decision promotion skill into .grok"
  assert_file_exists "$tmpdir/.grok/implementation.skill.md" "grok target should install the implementation skill into .grok"
  assert_file_exists "$tmpdir/.grok/implementation-validation.skill.md" "grok target should install the implementation validation skill into .grok"
  assert_file_content "$tmpdir/DECISIONS.yml" "grok-decisions-template" "grok target should install the shared decision template at the workspace root"
  assert_file_content "$tmpdir/.dodkit/templates/discussion-record.md" "grok-discussion-record-template" "grok target should install the shared discussion record template at its existing path"
}

run_tests() {
  test_parse_args_explicit_values
  test_parse_args_explicit_cursor_value
  test_parse_args_explicit_grok_value
  test_parse_args_defaults_target_when_missing
  test_parse_args_no_args_defaults
  test_parse_args_rejects_invalid_overwrite_value
  test_parse_args_rejects_missing_overwrite_value
  test_parse_args_rejects_legacy_force_option
  test_parse_args_rejects_repo_ref_options
  test_validate_target_rejects_unknown
  test_validate_target_accepts_cursor
  test_validate_target_accepts_grok
  test_copy_asset_installs_and_sets_permissions
  test_copy_asset_skips_when_unchanged
  test_copy_asset_updates_changed_file_by_default
  test_copy_asset_preserves_protected_decisions_file
  test_install_staged_asset_honors_no_policy
  test_install_staged_asset_honors_yes_policy
  test_confirm_overwrite_defaults_to_all_in_interactive_terminal
  test_confirm_overwrite_skips_on_explicit_no_in_interactive_terminal
  test_confirm_overwrite_all_switches_remaining_files_to_yes
  test_copy_asset_refuses_symlink_paths
  test_asset_specs_are_well_formed
  test_copilot_manifest_includes_discussion_record_template
  test_copilot_manifest_includes_skill_templates
  test_cursor_manifest_includes_discussion_record_template
  test_cursor_manifest_includes_rule_templates
  test_grok_manifest_includes_workspace_assets
  test_run_install_for_copilot_updates_managed_agent_and_preserves_decisions
  test_run_install_for_cursor_creates_expected_workspace_files
  test_run_install_for_grok_creates_expected_workspace_files
  printf '[PASS] install.sh function-level tests passed\n'
}

run_tests