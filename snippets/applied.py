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
    """Return the package receipt version for Jamf Extension Attribute use."""
    receipt_id = "com.google.Chrome"

    output = subprocess.run(
        ["pkgutil", "--pkg-info", receipt_id],
        capture_output=True,
        text=True
    ).stdout

    for line in output.splitlines():
        if line.startswith("version:"):
            version = line.split(":", 1)[1].strip()
            break

    print(f"<result>{version or 'Not Installed'}</result>")


def munki_script(mode="install"):
    """Perform install check on pkg receipt and exit with appropriate code for Munki."""
    receipt_id = "com.google.Chrome"

    result = subprocess.run(
        ["pkgutil", "--pkg-info", receipt_id],
        capture_output=True, text=True
    )

    if result.returncode == 0:
        sys.exit(1)  # already installed
    else:
        sys.exit(0)  # not installed


if __name__ == "__main__":
    write_launch_agent()
    jamf_ea()
    mode = sys.argv[1] if len(sys.argv) > 1 else "install"
    munki_script(mode)
