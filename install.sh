#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/nickovs/turso-skill.git"
SKILL_NAME="turso-db"

usage() {
  cat <<EOF
Usage: $0 [OPTIONS]

Install the turso-db skill for your AI coding agent.

Options:
  -g, --global    Install globally (default)
  -l, --local     Install locally (current project)
  -h, --help      Show this help message

Supported agents: Claude Code, Cursor, Windsurf, Cline, OpenCode

Examples:
  curl -fsSL https://raw.githubusercontent.com/nickovs/turso-skill/main/install.sh | bash
  curl -fsSL https://raw.githubusercontent.com/nickovs/turso-skill/main/install.sh | bash -s -- --local
EOF
}

clone_skill() {
  local tmp_dir
  tmp_dir=$(mktemp -d)
  trap "rm -rf '$tmp_dir'" EXIT
  echo "Fetching skill..."
  git clone --depth 1 --quiet "$REPO_URL" "$tmp_dir"
  CLONE_DIR="$tmp_dir"
}

install_claude_code() {
  local scope="$1"
  local target_dir
  if [[ "$scope" == "global" ]]; then
    target_dir="${HOME}/.claude/skills/${SKILL_NAME}"
  else
    target_dir=".claude/skills/${SKILL_NAME}"
  fi
  mkdir -p "$target_dir"
  [[ -d "$target_dir" ]] && rm -rf "$target_dir"
  cp -r "${CLONE_DIR}/skill/${SKILL_NAME}" "$target_dir"
  echo "  Claude Code: ${target_dir}"
}

install_cursor() {
  local scope="$1"
  local target_dir
  if [[ "$scope" == "global" ]]; then
    target_dir="${HOME}/.cursor/skills/${SKILL_NAME}"
  else
    target_dir=".cursor/skills/${SKILL_NAME}"
  fi
  mkdir -p "$target_dir"
  [[ -d "$target_dir" ]] && rm -rf "$target_dir"
  cp -r "${CLONE_DIR}/skill/${SKILL_NAME}" "$target_dir"
  echo "  Cursor: ${target_dir}"
}

install_windsurf() {
  local scope="$1"
  local target_dir
  if [[ "$scope" == "global" ]]; then
    target_dir="${HOME}/.windsurf/skills/${SKILL_NAME}"
  else
    target_dir=".windsurf/skills/${SKILL_NAME}"
  fi
  mkdir -p "$target_dir"
  [[ -d "$target_dir" ]] && rm -rf "$target_dir"
  cp -r "${CLONE_DIR}/skill/${SKILL_NAME}" "$target_dir"
  echo "  Windsurf: ${target_dir}"
}

install_cline() {
  local scope="$1"
  local target_dir
  if [[ "$scope" == "global" ]]; then
    target_dir="${HOME}/.cline/skills/${SKILL_NAME}"
  else
    target_dir=".cline/skills/${SKILL_NAME}"
  fi
  mkdir -p "$target_dir"
  [[ -d "$target_dir" ]] && rm -rf "$target_dir"
  cp -r "${CLONE_DIR}/skill/${SKILL_NAME}" "$target_dir"
  echo "  Cline: ${target_dir}"
}

install_opencode() {
  local scope="$1"
  local target_dir
  if [[ "$scope" == "global" ]]; then
    target_dir="${HOME}/.config/opencode/skill/${SKILL_NAME}"
  else
    target_dir=".opencode/skill/${SKILL_NAME}"
  fi
  mkdir -p "$target_dir"
  [[ -d "$target_dir" ]] && rm -rf "$target_dir"
  cp -r "${CLONE_DIR}/skill/${SKILL_NAME}" "$target_dir"
  echo "  OpenCode: ${target_dir}"
}

main() {
  local install_type="global"

  while [[ $# -gt 0 ]]; do
    case "$1" in
      -g|--global) install_type="global"; shift ;;
      -l|--local) install_type="local"; shift ;;
      -h|--help) usage; exit 0 ;;
      *) echo "Unknown option: $1"; usage; exit 1 ;;
    esac
  done

  echo "Installing ${SKILL_NAME} skill (${install_type})..."
  clone_skill

  echo "Installing for all supported agents..."
  install_claude_code "$install_type"
  install_cursor "$install_type"
  install_windsurf "$install_type"
  install_cline "$install_type"
  install_opencode "$install_type"

  echo "Done."
}

main "$@"
