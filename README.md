# python-vs-zsh-macadmins2026

This repo collects Python and zsh examples for macOS administration, with pros and cons for each approach.

## Why compare Python vs zsh

Python
- Pros: readable, strong standard library, better JSON/YAML support, easier error handling, portable across platforms.
- Cons: may require `python3` install or interpreter path, heavier for simple shell tasks, subprocess management can be more verbose.

zsh
- Pros: native shell access, ideal for quick one-liners, built-in file and process handling, already available on modern macOS.
- Cons: less structured for complex logic, poorer JSON/YAML handling, string parsing and error handling can be brittle.

---


## Repository structure

- `snippets/` — language-separated examples
  - `common_uses.py` / `common_uses.zsh` — logged-in user, local accounts, installers, API calls, JSON/YAML helpers
  - `files.py` / `files.zsh` — file find/read/copy/move/edit/remove/permissions helpers
  - `advanced.py` / `advanced.zsh` — positional args, functions, loops, arrays/dicts examples
  - `applied.py` / `applied.zsh` — LaunchAgent, Jamf EA (pkg receipt checks), Munki-style helpers

## Prerequisites

- macOS with `zsh` (default)
- `python3` (for the Python snippets)
- `jq` is used in several zsh examples for JSON parsing (install via Homebrew: `brew install jq`)
- For complex YAML handling in shell, consider `yq` or using the Python YAML examples (PyYAML)

## Usage

Browse the `snippets/` folder and copy the file(s) you need into your management scripts. Each snippet is self-contained and documented at the top of the file.

Examples are intentionally short; prefer the Python version for structured data (JSON/YAML) and the zsh version for quick system-level tasks.

## Jamf Extension Attribute examples

The `applied` snippets include Jamf EA examples that read package receipts and print a `<result>...</result>` value suitable for Jamf.

## Contributing

Contributions welcome — open a PR with small, focused examples or improvements to existing snippets.

```


