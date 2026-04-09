#!/usr/bin/env bash

set -euo pipefail

TARGET_CLI=""
FORCE_OVERWRITE=0

SOURCE_REPOSITORY="mkgask/DODKit"
SOURCE_REF="main"

COPILOT_SOURCES=(
  "templates/agent.md"
  "templates/DECISIONS.yml"
)

COPILOT_DESTINATIONS=(
  ".github/agents/dod.agent.md"
  "DECISIONS.yml"
)

print_usage() {
  cat <<'USAGE'
Usage:
  install.sh [copilot] [--force]

Description:
  Install DOD assets for GitHub Copilot customization into the current workspace.

Arguments:
  copilot                 Optional explicit target. Defaults to copilot.

Options:
  --force                 Overwrite existing target files without interactive prompt.
  -h, --help              Show this help.
USAGE
}

has_tty() {
  [[ -r /dev/tty ]] && [[ -w /dev/tty ]]
}

supports_color() {
  [[ -t 1 ]] && [[ -z "${NO_COLOR:-}" ]]
}

colorize() {
  local color_code="$1"
  local message="$2"

  if supports_color; then
    printf '\033[%sm%s\033[0m\n' "$color_code" "$message"
  else
    printf '%s\n' "$message"
  fi
}

log_info() {
  printf '[INFO] %s\n' "$1"
}

log_success() {
  colorize "32" "[SUCCESS] $1"
}

log_warning() {
  colorize "33" "[WARNING] $1"
}

log_error() {
  if supports_color; then
    printf '\033[31m[ERROR] %s\033[0m\n' "$1" >&2
  else
    printf '[ERROR] %s\n' "$1" >&2
  fi
}

die() {
  log_error "$1"
  exit 1
}

require_command() {
  local command_name="$1"
  if ! command -v "$command_name" >/dev/null 2>&1; then
    die "Required command not found: $command_name"
  fi
}

interactive_setup() {
  TARGET_CLI="copilot"
  FORCE_OVERWRITE=0
  log_info "No arguments provided. Using defaults: target=copilot overwrite=prompt-on-conflict"
}

parse_args() {
  if [[ $# -eq 0 ]]; then
    interactive_setup
    return 0
  fi

  while [[ $# -gt 0 ]]; do
    case "$1" in
      copilot)
        TARGET_CLI="$1"
        shift
        ;;
      --force)
        FORCE_OVERWRITE=1
        shift
        ;;
      -h|--help)
        print_usage
        exit 0
        ;;
      *)
        die "Unknown argument: $1"
        ;;
    esac
  done

  if [[ -z "$TARGET_CLI" ]]; then
    TARGET_CLI="copilot"
    log_warning "No target was provided. Defaulting to 'copilot'."
  fi
}

validate_target() {
  if [[ "$TARGET_CLI" != "copilot" ]]; then
    die "Unsupported target '$TARGET_CLI'. Only 'copilot' is supported in this release."
  fi
}

confirm_overwrite() {
  local destination_path="$1"
  local answer=""

  if has_tty; then
    printf '[WARNING] File exists: %s\n' "$destination_path" >/dev/tty
    printf 'Overwrite this file? [y/N]: ' >/dev/tty
    read -r answer </dev/tty || true

    case "$answer" in
      y|Y|yes|YES)
        return 0
        ;;
      *)
        return 1
        ;;
    esac
  fi

  if [[ ! -t 0 ]]; then
    log_warning "Non-interactive execution detected; preserving existing file: $destination_path"
    return 1
  fi

  printf '[WARNING] File exists: %s\n' "$destination_path"
  printf 'Overwrite this file? [y/N]: '
  read -r answer

  case "$answer" in
    y|Y|yes|YES)
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

create_parent_directory() {
  local destination_path="$1"
  local destination_dir=""

  destination_dir="$(dirname "$destination_path")"

  if [[ "$destination_dir" != "." ]]; then
    mkdir -p "$destination_dir"
  fi
}

copy_asset() {
  local source_path="$1"
  local destination_path="$2"
  local temporary_file=""
  local source_url=""

  source_url="https://raw.githubusercontent.com/${SOURCE_REPOSITORY}/${SOURCE_REF}/${source_path}"
  temporary_file="$(mktemp)"

  if ! curl -fsSL "$source_url" -o "$temporary_file"; then
    rm -f "$temporary_file"
    die "Failed to download source asset: $source_url"
  fi

  create_parent_directory "$destination_path"

  if [[ -f "$destination_path" ]]; then
    if cmp -s "$temporary_file" "$destination_path"; then
      rm -f "$temporary_file"
      log_info "Already up-to-date: $destination_path"
      return 2
    fi

    if [[ "$FORCE_OVERWRITE" -ne 1 ]] && ! confirm_overwrite "$destination_path"; then
      rm -f "$temporary_file"
      log_warning "Skipped existing file: $destination_path"
      return 1
    fi
  fi

  cp "$temporary_file" "$destination_path"
  chmod 0644 "$destination_path"
  rm -f "$temporary_file"
  log_success "Installed: $destination_path"
  return 0
}

print_validation_steps() {
  cat <<'VALIDATION'
Validation steps:
1. Confirm the installed files exist:
   - .github/agents/dod.agent.md
   - DECISIONS.yml
2. Review local changes before commit:
   - git status
3. Open the installed agent file and confirm expected content:
   - .github/agents/dod.agent.md
VALIDATION
}

run_install_for_copilot() {
  local index=0
  local installed_count=0
  local skipped_count=0
  local unchanged_count=0
  local source_path=""
  local destination_path=""

  for index in "${!COPILOT_SOURCES[@]}"; do
    source_path="${COPILOT_SOURCES[$index]}"
    destination_path="${COPILOT_DESTINATIONS[$index]}"

    if copy_asset "$source_path" "$destination_path"; then
      installed_count=$((installed_count + 1))
    else
      case "$?" in
        1)
          skipped_count=$((skipped_count + 1))
          ;;
        2)
          unchanged_count=$((unchanged_count + 1))
          ;;
      esac
    fi
  done

  log_success "Installer finished. installed=$installed_count skipped=$skipped_count unchanged=$unchanged_count"
  print_validation_steps
}

main() {
  parse_args "$@"
  require_command "curl"
  require_command "mktemp"

  validate_target

  log_info "Starting installer target=$TARGET_CLI source=${SOURCE_REPOSITORY}@${SOURCE_REF}"
  run_install_for_copilot
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  main "$@"
fi
