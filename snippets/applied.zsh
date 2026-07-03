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

# Run a Jamf policy event for an extension attribute or policy trigger.
jamf_ea() {
  /usr/sbin/jamf policy -event myEA
}

# Perform a Munki-style install or uninstall action.
munki_script() {
  local mode=${1:-install}
  if [[ $mode == install ]]; then
    /usr/sbin/installer -pkg "/tmp/MyApp.pkg" -target /
  elif [[ $mode == uninstall ]]; then
    rm -rf "/Applications/MyApp.app"
  else
    echo "Unknown mode: $mode"
    return 1
  fi
}

local script_mode="$1"
write_launch_agent
jamf_ea
munki_script "$script_mode"
