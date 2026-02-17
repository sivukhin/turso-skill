#!/bin/bash
set -euo pipefail

SKILL_DIR="${HOME}/.claude/skills/turso-db"

echo "Installing turso-db skill to ${SKILL_DIR}..."

# Get the directory where this script lives
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Create target directory
mkdir -p "${SKILL_DIR}/references" "${SKILL_DIR}/sdks"

# Copy all skill files
cp "${SCRIPT_DIR}/SKILL.md" "${SKILL_DIR}/"
cp "${SCRIPT_DIR}/references/"*.md "${SKILL_DIR}/references/"
cp "${SCRIPT_DIR}/sdks/"*.md "${SKILL_DIR}/sdks/"

echo "Installed turso-db skill successfully."
echo "Use /turso-db in Claude Code to activate."
