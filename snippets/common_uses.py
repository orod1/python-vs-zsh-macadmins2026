#!/usr/bin/env python3
"""
Common macOS admin snippets: logged in user, local accounts, installer,
API call, and JSON/YAML processing.
"""
import json
import os
import pwd
import subprocess
import sys
import urllib.request
from pathlib import Path


def logged_in_user():
    """Return the currently logged-in console user."""
    user = os.getlogin()
    print(user)
    return user


def local_accounts():
    """Return a list of local accounts with UIDs at or above 501."""
    return [u.pw_name for u in pwd.getpwall() if int(u.pw_uid) >= 501]


def run_installer(pkg_path):
    """Install a package bundle at the given path to the local machine."""
    subprocess.run(["installer", "-pkg", pkg_path, "-target", "/"], check=True)


def api_call():
    """Query a remote API and print the GitHub repository full name."""
    url = "https://api.github.com/repos/python/cpython"
    req = urllib.request.Request(url, headers={"User-Agent": "macadmin-script"})
    with urllib.request.urlopen(req) as resp:
        data = json.load(resp)
    print(data["full_name"])
    return data


def process_json(payload):
    """Parse JSON payload and print the name field from the resulting object."""
    obj = json.loads(payload)
    print(obj.get("name"))
    return obj


if __name__ == "__main__":
    print("Logged in user:", logged_in_user())
    print("Local accounts:", local_accounts())
