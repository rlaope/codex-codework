#!/usr/bin/env bash
set -euo pipefail

repo="rlaope/codex-codework"
ref="${CODEWORK_REF:-main}"
skill_name="codework"
codex_home="${CODEX_HOME:-$HOME/.codex}"
dest_root="$codex_home/skills"
dest="$dest_root/$skill_name"
tmp="${TMPDIR:-/tmp}/codex-codework-install.$$"
backup=""

cleanup() {
  rm -rf "$tmp"
}
trap cleanup EXIT

mkdir -p "$tmp" "$dest_root"

script_dir=""
if [ -n "${BASH_SOURCE[0]:-}" ] && [ -f "${BASH_SOURCE[0]}" ]; then
  script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
fi

source_dir=""
if [ -n "$script_dir" ] && [ -f "$script_dir/skills/codework/SKILL.md" ]; then
  source_dir="$script_dir/skills/codework"
else
  archive="$tmp/codex-codework.tar.gz"
  url="https://codeload.github.com/$repo/tar.gz/$ref"

  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$url" -o "$archive"
  elif command -v wget >/dev/null 2>&1; then
    wget -qO "$archive" "$url"
  else
    echo "codex-codework install requires curl or wget." >&2
    exit 1
  fi

  tar -xzf "$archive" -C "$tmp"
  skill_file="$(find "$tmp" -path "*/skills/codework/SKILL.md" -print -quit)"
  if [ -z "$skill_file" ]; then
    echo "Could not find skills/codework in $repo@$ref." >&2
    exit 1
  fi
  source_dir="$(dirname "$skill_file")"
fi

staged="$tmp/$skill_name"
mkdir -p "$staged"
cp -R "$source_dir/." "$staged/"

if [ ! -f "$staged/SKILL.md" ]; then
  echo "Downloaded skill is missing SKILL.md." >&2
  exit 1
fi

if [ -d "$dest" ] && diff -qr "$dest" "$staged" >/dev/null 2>&1; then
  echo "codework skill is already up to date at $dest"
  echo "Restart Codex to pick up the skill, then invoke it with \$codework."
  exit 0
fi

if [ -e "$dest" ]; then
  backup="${dest}.backup.$(date -u +%Y%m%dT%H%M%SZ)"
  mv "$dest" "$backup"
fi

if ! mv "$staged" "$dest"; then
  if [ -n "$backup" ] && [ -e "$backup" ]; then
    mv "$backup" "$dest"
  fi
  echo "Failed to install codework skill." >&2
  exit 1
fi

echo "Installed codework skill to $dest"
if [ -n "$backup" ]; then
  echo "Previous installation backed up to $backup"
fi
echo "Restart Codex to pick up the skill, then invoke it with \$codework."
