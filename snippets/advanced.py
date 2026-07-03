#!/usr/bin/env python3
"""
Advanced scripting examples for positional arguments, functions, error logging,
prompting, and loops.
"""
import logging
import subprocess
import sys

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Require a positional argument and return it if provided.
def require_arg():
    if len(sys.argv) < 2:
        print("Usage: advanced.py <user>")
        raise SystemExit(1)
    return sys.argv[1]

# Python does not have a native installer function, but we can wrap the installer subcommand run function.
def install_pkg(pkg_path):
    """Install a package by invoking the system installer command."""
    subprocess.run(["installer", "-pkg", pkg_path, "-target", "/"], check=True)


def log_error():
    """Run a command and log an error message if it fails."""
    try:
        subprocess.run(["false"], check=True)
    except subprocess.CalledProcessError as exc:
        logger.error("Command failed: %s", exc)
        raise


def prompt_username():
    """Prompt interactively for a username if one was not passed in."""
    username = sys.argv[1] if len(sys.argv) > 1 else None
    if not username:
        username = input("Enter username: ")
    return username


def loops():
    """Demonstrate simple for and while loop constructs."""
    for i in range(3):
        print(f"Iteration {i}")

    count = 0
    while count < 3:
        print(f"Count {count}")
        count += 1

def list_dict_examples():
    """Show Python list and dict usage with basic access and iteration."""
    fruits = ["apple", "banana", "cherry"]
    print("List element 1:", fruits[0])

    user_info = {
        "name": "alice",
        "role": "admin",
    }
    print("Dict name:", user_info["name"])
    print("Dict role:", user_info["role"])

    for fruit in fruits:
        print(f"Fruit: {fruit}")

    for key, value in user_info.items():
        print(f"{key}: {value}")

if __name__ == "__main__":
    print("Target user:", require_arg())
    print("Prompt:", prompt_username())
    loops()
    list_dict_examples()
