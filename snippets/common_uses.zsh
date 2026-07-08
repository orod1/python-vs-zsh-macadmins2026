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

# Get an OAuth access token from a Jamf Pro server using API credentials.
url="https://company.jamf.training"
client_id="0b59164c-334b-4627-8f0f-e9acb7b06a5d"
client_secret="X4yFXP-H8Ald1tG0UtCU1SHKId5L8N6f0BcDFJaUkWu8NS7ZuEb_nDPhIiTIJLe5"
api_get_access_token() {
	response=$(curl --silent --location --request POST "${url}/api/oauth/token" \
		--header "Content-Type: application/x-www-form-urlencoded" \
		--data-urlencode "client_id=${client_id}" \
		--data-urlencode "grant_type=client_credentials" \
		--data-urlencode "client_secret=${client_secret}")
	access_token=$(echo "$response" | plutil -extract access_token raw -)
}

# Parse JSON payload and print the name field.
process_json() {
  local json_payload="$1"
  printf '%s' "$json_payload" | jq -r '.name'
}

echo "Logged in user: $(logged_in_user)"
echo "Local accounts:"
local_accounts
