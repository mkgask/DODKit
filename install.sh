#!/usr/bin/env bash

set -euo pipefail

TARGET_CLI=""
FORCE_OVERWRITE=0

SOURCE_REPOSITORY="mkgask/DODKit"
SOURCE_REF="main"

COPILOT_ASSET_SPECS=(
  "templates/agent.md|.github/agents/dod.agent.md|DOD agent"
  "templates/DECISIONS.yml|DECISIONS.yml|DOD decisions"
  "templates/discussion-record.md|.dodkit/templates/discussion-record.md|DOD discussion record template"
  "templates/skills/discussion.skill.md|.github/skills/discussion/SKILL.md|DOD discussion skill"
  "templates/skills/discussion-validation.skill.md|.github/skills/discussion-validation/SKILL.md|DOD discussion validation skill"
  "templates/skills/decision-promotion.skill.md|.github/skills/decision-promotion/SKILL.md|DOD decision promotion skill"
  "templates/skills/implementation.skill.md|.github/skills/implementation/SKILL.md|DOD implementation skill"
  "templates/skills/implementation-validation.skill.md|.github/skills/implementation-validation/SKILL.md|DOD implementation validation skill"
)

CURSOR_ASSET_SPECS=(
  "templates/agent.md|.cursor/rules/dod-implementation-agent.mdc|DOD main controller instructions for manual use in Cursor."
  "templates/DECISIONS.yml|DECISIONS.yml|DOD decisions"
  "templates/discussion-record.md|.dodkit/templates/discussion-record.md|DOD discussion record template"
  "templates/skills/discussion.skill.md|.cursor/rules/discussion.mdc|DOD Gate A step 1 discussion procedure for manual use in Cursor."
  "templates/skills/discussion-validation.skill.md|.cursor/rules/discussion-validation.mdc|DOD Gate A step 2 discussion-validation procedure for manual use in Cursor."
  "templates/skills/decision-promotion.skill.md|.cursor/rules/decision-promotion.mdc|DOD Gate A step 3 decision-promotion procedure for manual use in Cursor."
  "templates/skills/implementation.skill.md|.cursor/rules/implementation.mdc|DOD Gate B implementation procedure for manual use in Cursor."
  "templates/skills/implementation-validation.skill.md|.cursor/rules/implementation-validation.mdc|DOD Gate B and Gate C implementation-validation procedure for manual use in Cursor."
)

# Files that must never be overwritten, even with --force.
# These contain project-specific data that would be lost on overwrite.
PROTECT_FROM_OVERWRITE=(
  "DECISIONS.yml"
)

print_usage() {
  cat <<'USAGE'
Usage:
  install.sh [copilot|cursor] [--force]

Description:
  Install DOD assets for a supported editor customization target into the current workspace.

Arguments:
  copilot                 Optional explicit target for GitHub Copilot assets. Defaults to copilot.
  cursor                  Optional explicit target for Cursor project rule assets.

Options:
  --force                 Overwrite existing target files without interactive prompt.
  -h, --help              Show this help.
USAGE
}

has_tty() {
  [[ -r /dev/tty ]] && [[ -w /dev/tty ]]
}

path_has_symlink_component() {
  local target_path="$1"

  while [[ "$target_path" != "." && "$target_path" != "/" ]]; do
    if [[ -L "$target_path" ]]; then
      return 0
    fi
    target_path="$(dirname "$target_path")"
  done

  return 1
}

supports_color() {
  [[ -t 1 ]] && [[ -z "${NO_COLOR:-}" ]]
}

log_info() {
  printf '[INFO] %s\n' "$1"
}

log_success() {
  if supports_color; then
    printf '\033[32m[✅️SUCCESS] %s\033[0m\n' "$1"
  else
    printf '[✅️SUCCESS] %s\n' "$1"
  fi
}

log_warning() {
  if supports_color; then
    printf '\033[33m[⚠️WARNING] %s\033[0m\n' "$1"
  else
    printf '[⚠️WARNING] %s\n' "$1"
  fi
}

log_error() {
  if supports_color; then
    printf '\033[31m[❌ERROR] %s\033[0m\n' "$1" >&2
  else
    printf '[❌ERROR] %s\n' "$1" >&2
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
      copilot|cursor)
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
  case "$TARGET_CLI" in
    copilot|cursor)
      return 0
      ;;
    *)
      die "Unsupported target '$TARGET_CLI'. Supported targets are: copilot, cursor."
      ;;
  esac
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
  local asset_name="${3:-$destination_path}"
  local temporary_file=""
  temporary_file="$(mktemp)"

  if ! download_asset_to_file "$source_path" "$temporary_file"; then
    rm -f "$temporary_file"
    die "Failed to download source asset '$asset_name': $source_path"
  fi

  install_staged_asset "$temporary_file" "$destination_path"
}

download_asset_to_file() {
  local source_path="$1"
  local output_file="$2"
  local source_url=""

  source_url="https://raw.githubusercontent.com/${SOURCE_REPOSITORY}/${SOURCE_REF}/${source_path}"

  if ! curl --proto '=https' --tlsv1.2 -fsSL "$source_url" -o "$output_file"; then
    return 1
  fi

  return 0
}

extract_markdown_body_without_frontmatter() {
  local source_file="$1"
  local output_file="$2"

  awk '
    BEGIN {
      keep_leading_blank_lines = 0
    }

    NR == 1 && $0 == "---" {
      in_frontmatter = 1
      next
    }

    in_frontmatter {
      if ($0 == "---") {
        in_frontmatter = 0
      }
      next
    }

    {
      if (!keep_leading_blank_lines && $0 == "") {
        next
      }

      keep_leading_blank_lines = 1
      print
    }
  ' "$source_file" > "$output_file"
}

render_cursor_rule_asset() {
  local source_path="$1"
  local destination_path="$2"
  local rule_description="$3"
  local downloaded_file=""
  local body_file=""
  local rendered_file=""

  downloaded_file="$(mktemp)"
  body_file="$(mktemp)"
  rendered_file="$(mktemp)"

  if ! download_asset_to_file "$source_path" "$downloaded_file"; then
    rm -f "$downloaded_file" "$body_file" "$rendered_file"
    die "Failed to download source asset: $source_path"
  fi

  extract_markdown_body_without_frontmatter "$downloaded_file" "$body_file"

  printf -- '---\ndescription: %s\nalwaysApply: false\n---\n\n' "$rule_description" > "$rendered_file"
  cat "$body_file" >> "$rendered_file"

  rm -f "$downloaded_file" "$body_file"
  install_staged_asset "$rendered_file" "$destination_path"
}

install_staged_asset() {
  local staged_file="$1"
  local destination_path="$2"

  if path_has_symlink_component "$destination_path"; then
    rm -f "$staged_file"
    log_warning "Refusing to write through symlink path: $destination_path"
    return 1
  fi

  create_parent_directory "$destination_path"

  if [[ -f "$destination_path" ]]; then
    if cmp -s "$staged_file" "$destination_path"; then
      rm -f "$staged_file"
      log_info "Already up-to-date: $destination_path"
      return 2
    fi

    local protected_entry
    for protected_entry in "${PROTECT_FROM_OVERWRITE[@]}"; do
      if [[ "$destination_path" == "$protected_entry" ]]; then
        rm -f "$staged_file"
        log_warning "Protected file preserved (project data must not be overwritten): $destination_path"
        return 1
      fi
    done

    if [[ "$FORCE_OVERWRITE" -ne 1 ]] && ! confirm_overwrite "$destination_path"; then
      rm -f "$staged_file"
      log_warning "Skipped existing file: $destination_path"
      return 1
    fi
  fi

  cp "$staged_file" "$destination_path"
  chmod 0644 "$destination_path"
  rm -f "$staged_file"
  log_success "Installed: $destination_path"
  return 0
}

print_validation_steps() {
  case "$TARGET_CLI" in
    copilot)
      cat <<'VALIDATION'
Validation steps:
1. Confirm the installed files exist:
   - .github/agents/dod.agent.md
   - .dodkit/templates/discussion-record.md
   - DECISIONS.yml
   - .github/skills/discussion/SKILL.md
   - .github/skills/discussion-validation/SKILL.md
   - .github/skills/decision-promotion/SKILL.md
   - .github/skills/implementation/SKILL.md
   - .github/skills/implementation-validation/SKILL.md
2. Review local changes before commit:
   - git status
3. Open the installed agent and skill files and confirm expected content:
   - .github/agents/dod.agent.md
   - .github/skills/discussion/SKILL.md
VALIDATION
      ;;
    cursor)
      cat <<'VALIDATION'
Validation steps:
1. Confirm the installed files exist:
   - .cursor/rules/dod-implementation-agent.mdc
   - .cursor/rules/discussion.mdc
   - .cursor/rules/discussion-validation.mdc
   - .cursor/rules/decision-promotion.mdc
   - .cursor/rules/implementation.mdc
   - .cursor/rules/implementation-validation.mdc
   - .dodkit/templates/discussion-record.md
   - DECISIONS.yml
2. Review local changes before commit:
   - git status
3. Open the installed Cursor rule files and confirm expected content:
   - .cursor/rules/dod-implementation-agent.mdc
   - .cursor/rules/discussion.mdc
VALIDATION
      ;;
  esac
}

run_install_for_target() {
  local installed_count=0
  local skipped_count=0
  local unchanged_count=0
  local install_status=0
  local asset_spec=""
  local asset_specs=()
  local source_path=""
  local destination_path=""
  local asset_name=""

  case "$TARGET_CLI" in
    copilot)
      asset_specs=("${COPILOT_ASSET_SPECS[@]}")
      ;;
    cursor)
      asset_specs=("${CURSOR_ASSET_SPECS[@]}")
      ;;
  esac

  for asset_spec in "${asset_specs[@]}"; do
    IFS='|' read -r source_path destination_path asset_name <<< "$asset_spec"

    if [[ -z "$source_path" ]] || [[ -z "$destination_path" ]] || [[ -z "$asset_name" ]]; then
      die "Invalid asset spec: $asset_spec"
    fi

    if [[ "$TARGET_CLI" == "cursor" ]] && [[ "$destination_path" == *.mdc ]]; then
      if render_cursor_rule_asset "$source_path" "$destination_path" "$asset_name"; then
        install_status=0
      else
        install_status="$?"
      fi
    else
      if copy_asset "$source_path" "$destination_path" "$asset_name"; then
        install_status=0
      else
        install_status="$?"
      fi
    fi

    if [[ "$install_status" -eq 0 ]]; then
      installed_count=$((installed_count + 1))
    else
      case "$install_status" in
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
  run_install_for_target
}

if [[ "${BASH_SOURCE[0]:-$0}" == "$0" ]]; then
  main "$@"
fi
