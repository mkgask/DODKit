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

run_tests() {
  test_parse_args_explicit_values
  test_parse_args_defaults_target_when_missing
  test_parse_args_no_args_defaults
  test_parse_args_rejects_repo_ref_options
  test_validate_target_rejects_unknown
  test_copy_asset_installs_and_sets_permissions
  test_copy_asset_skips_when_unchanged
  printf '[PASS] install.sh function-level tests passed\n'
}

run_tests