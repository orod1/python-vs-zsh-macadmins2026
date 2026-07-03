#!/usr/bin/env python3
"""
Applied macOS admin scripts for LaunchAgents, Jamf EA, and Munki-style scripts.
"""
import plistlib
import subprocess
from pathlib import Path
import sys


def write_launch_agent():
    """Write a LaunchAgent plist to the user's Library folder."""
    plist = {
        "Label": "com.example.hello",
        "ProgramArguments": ["/usr/bin/python3", "/usr/local/bin/hello.py"],
        "RunAtLoad": True,
    }
    Path("~/Library/LaunchAgents/com.example.hello.plist").expanduser().write_bytes(plistlib.dumps(plist))


def jamf_ea():
    """Run a Jamf Extension Attribute-style policy event."""
    result = subprocess.run(["/usr/sbin/jamf", "policy", "-event", "myEA"], check=True, capture_output=True, text=True)
    print(result.stdout)


def munki_script(mode="install"):
    """Perform a Munki-style install or uninstall operation based on mode."""
    if mode == "install":
        subprocess.run(["/usr/sbin/installer", "-pkg", "/tmp/MyApp.pkg", "-target", "/"], check=True)
    elif mode == "uninstall":
        subprocess.run(["rm", "-rf", "/Applications/MyApp.app"], check=True)
    else:
        print(f"Unknown mode: {mode}")
        raise SystemExit(1)


if __name__ == "__main__":
    write_launch_agent()
    jamf_ea()
    mode = sys.argv[1] if len(sys.argv) > 1 else "install"
    munki_script(mode)
