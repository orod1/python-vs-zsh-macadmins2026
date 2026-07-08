#!/bin/zsh
# Applied macOS admin snippets: LaunchAgents, Jamf EA, Munki.

# Write a LaunchAgent plist to the user's LaunchAgents folder.
write_launch_agent() {
  cat > ~/Library/LaunchAgents/com.example.hello.plist <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>com.example.hello</string>
  <key>ProgramArguments</key>
  <array>
    <string>/usr/bin/python3</string>
    <string>/usr/local/bin/hello.py</string>
  </array>
  <key>RunAtLoad</key>
  <true/>
</dict>
</plist>
EOF
}

# Return the package receipt version for Jamf Extension Attribute use.
jamf_ea() {
  receipt_id="com.google.Chrome"
  version=$(pkgutil --pkg-info "${receipt_id}" 2>/dev/null | awk -F': ' '/version:/ {print $2; exit}')
  if [[ -n "$version" ]]; then
    echo "<result>${version}</result>"
  else
    echo "<result>Not Installed</result>"
  fi
}

# Perform install check on pkg receipt and exit with appropriate code for Munki..
munki_script() {
  receipt_id="com.google.Chrome"

  if pkgutil --pkg-info "${receipt_id}" &>/dev/null; then
      # Already installed
      exit 1
  else
      # Not installed
      exit 0
  fi
}

local script_mode="$1"
write_launch_agent
jamf_ea
munki_script 
