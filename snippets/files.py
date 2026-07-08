#!/usr/bin/env python3
"""
File operations for macOS admin scripts: find, read, copy, edit,
permissions, remove, and create.
"""
import shutil
import os
from pathlib import Path


def find_files(root, pattern):
    """Find files recursively under root matching the glob pattern."""
    return list(Path(root).rglob(pattern))


def read_file(path):
    """Read and return the text contents of the specified file."""
    return Path(path).read_text(encoding="utf-8")


def copy_file(src, dst):
    """Copy a file from src to dst, preserving metadata."""
    shutil.copy2(src, dst)


def move_file(src, dst):
    """Move or rename a file from src to dst."""
    shutil.move(src, dst)


def edit_file(path, old, new):
    """Replace text in a file and write the updated contents back."""
    text = read_file(path)
    text = text.replace(old, new)
    Path(path).write_text(text, encoding="utf-8")


def chmod_file(path, mode):
    """Change permissions on a file at the specified path."""
    Path(path).chmod(mode)


def remove_file(path):
    """Delete the specified file from disk."""
    os.remove(path) # Remove file
    os.rmdir(path)  # Remove directory


def create_file(path, contents):
    """Create a file and write the provided contents to it."""
    Path(path).write_text(contents, encoding="utf-8")


if __name__ == "__main__":
    for path in find_files("/tmp", "*.log"):
        print(path)
