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

reset_installer_state() {
  TARGET_CLI=""
  FORCE_OVERWRITE=0
}

test_parse_args_explicit_values() {
  reset_installer_state
  parse_args copilot --force

  assert_eq "$TARGET_CLI" "copilot" "parse_args should set explicit target"
  assert_eq "$FORCE_OVERWRITE" "1" "parse_args should enable force overwrite"
}

test_parse_args_explicit_cursor_value() {
  reset_installer_state
  parse_args cursor --force

  assert_eq "$TARGET_CLI" "cursor" "parse_args should accept cursor as an explicit target"
  assert_eq "$FORCE_OVERWRITE" "1" "parse_args should enable force overwrite for cursor"
}

test_parse_args_defaults_target_when_missing() {
  reset_installer_state
  parse_args --force

  assert_eq "$TARGET_CLI" "copilot" "parse_args should default target to copilot"
  assert_eq "$FORCE_OVERWRITE" "1" "parse_args should still parse force option"
}

test_parse_args_no_args_defaults() {
  reset_installer_state
  parse_args

  assert_eq "$TARGET_CLI" "copilot" "parse_args with no args should default target to copilot"
  assert_eq "$FORCE_OVERWRITE" "0" "parse_args with no args should keep overwrite prompt behavior"
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
  FORCE_OVERWRITE=1

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
  FORCE_OVERWRITE=0

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
  FORCE_OVERWRITE=1

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
  FORCE_OVERWRITE=1

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

run_tests() {
  test_parse_args_explicit_values
  test_parse_args_explicit_cursor_value
  test_parse_args_defaults_target_when_missing
  test_parse_args_no_args_defaults
  test_parse_args_rejects_repo_ref_options
  test_validate_target_rejects_unknown
  test_validate_target_accepts_cursor
  test_copy_asset_installs_and_sets_permissions
  test_copy_asset_skips_when_unchanged
  test_copy_asset_refuses_symlink_paths
  test_asset_specs_are_well_formed
  test_copilot_manifest_includes_discussion_record_template
  test_copilot_manifest_includes_skill_templates
  test_cursor_manifest_includes_discussion_record_template
  test_cursor_manifest_includes_rule_templates
  test_run_install_for_cursor_creates_expected_workspace_files
  printf '[PASS] install.sh function-level tests passed\n'
}

run_tests