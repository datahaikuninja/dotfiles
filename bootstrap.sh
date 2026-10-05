#!/bin/bash
# Entry point for a fresh Mac. Installs yadm, clones dotfiles, runs `yadm bootstrap`.
#   curl -fsSL https://raw.githubusercontent.com/datahaikuninja/dotfiles/main/bootstrap.sh | bash
set -euo pipefail

REPO_URL="${DOTFILES_REPO_URL:-https://github.com/datahaikuninja/dotfiles.git}"
BRANCH="${DOTFILES_BRANCH:-main}"
BIN_DIR="$HOME/.local/bin"

# git comes from Xcode Command Line Tools
if ! xcode-select -p >/dev/null 2>&1; then
  xcode-select --install
  echo "Re-run this script after the Command Line Tools installation finishes."
  exit 1
fi

# yadm is a single shell script; no package manager needed
mkdir -p "$BIN_DIR"
if [[ ! -x "$BIN_DIR/yadm" ]]; then
  curl -fsSLo "$BIN_DIR/yadm" https://github.com/yadm-dev/yadm/raw/master/yadm
  chmod +x "$BIN_DIR/yadm"
fi
export PATH="$BIN_DIR:$PATH"

if [[ ! -d "$HOME/.local/share/yadm/repo.git" ]]; then
  yadm clone --no-bootstrap -b "$BRANCH" "$REPO_URL"
fi

yadm bootstrap
