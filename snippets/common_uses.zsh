#!/bin/zsh
# Common macOS admin snippets in zsh.

# Return the currently logged-in console user.
logged_in_user() {
  stat -f%Su /dev/console
}

# List local user accounts with UIDs at or above 501.
local_accounts() {
  awk -F: '$3 >= 501 && $3 != 65534 {print $1}' /etc/passwd
}

# Install a package bundle using the system installer.
run_installer() {
  local pkg_path="$1"
  sudo installer -pkg "$pkg_path" -target /
}

# Call a REST API and print the GitHub repo full name.
api_call() {
  curl -s -H "User-Agent: macadmin-script" "https://api.github.com/repos/python/cpython" | jq -r '.full_name'
}

# Parse JSON payload and print the name field.
process_json() {
  local json_payload="$1"
  printf '%s' "$json_payload" | jq -r '.name'
}

echo "Logged in user: $(logged_in_user)"
echo "Local accounts:"
local_accounts
