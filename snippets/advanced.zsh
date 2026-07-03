#!/bin/zsh
# Advanced scripting in zsh.

# Require a positional argument and return it if present.
require_arg() {
  if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <user>"
    exit 1
  fi
  print -- "$1"
}

# Install a package using the installer command.
install_pkg() {
  local pkg_path="$1"
  sudo installer -pkg "$pkg_path" -target /
}

# Log an error message and return failure if a command fails.
log_error() {
  if ! false; then
    echo "ERROR: installer failed" >&2
    return 1
  fi
}

# Prompt for a username if it was not provided as an argument.
prompt_username() {
  local provided_username=${1:-}
  if [[ -z $provided_username ]]; then
    read -r "username?Enter username: "
  fi
  print -- "$provided_username"
}

# Demonstrate for-loop and while-loop control flow.
loops() {
  for i in {0..2}; do
    echo "Iteration $i"
  done

  local count=0
  while [[ $count -lt 3 ]]; do
    echo "Count $count"
    ((count++))
  done
}

local script_user="$1"
local script_prompt="$2"

echo "Target user: $(require_arg "$script_user")"
echo "Prompt: $(prompt_username "$script_prompt")"
loops
