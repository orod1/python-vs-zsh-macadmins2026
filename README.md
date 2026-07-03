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

## Snippet files

The code snippets are grouped into these files in `snippets/`:

- `snippets/common_uses.py`
- `snippets/common_uses.zsh`
- `snippets/files.py`
- `snippets/files.zsh`
- `snippets/advanced.py`
- `snippets/advanced.zsh`
- `snippets/applied.py`
- `snippets/applied.zsh`

For a brief overview, see `snippets/README.md`.

---

## Common uses

### Getting a logged in user

Python
```python
import os
import pwd

user = os.getlogin()
user_info = pwd.getpwnam(user)
print(user)
print(user_info.pw_dir)
```

zsh
```zsh
user=$(stat -f%Su /dev/console)
echo "$user"
```

### Searching for all local accounts

Python
```python
import pwd

local_accounts = [u.pw_name for u in pwd.getpwall() if int(u.pw_uid) >= 501]
for account in local_accounts:
    print(account)
```

zsh
```zsh
awk -F: '$3 >= 501 && $3 != 65534 {print $1}' /etc/passwd
```

### Running an installer

Python
```python
import subprocess

pkg_path = "/tmp/example.pkg"
subprocess.run(["installer", "-pkg", pkg_path, "-target", "/"], check=True)
```

zsh
```zsh
pkg_path="/tmp/example.pkg"
sudo installer -pkg "$pkg_path" -target /
```

### Run an API call

Python
```python
import json
import urllib.request

url = "https://api.github.com/repos/python/cpython"
req = urllib.request.Request(url, headers={"User-Agent": "macadmin-script"})
with urllib.request.urlopen(req) as resp:
    data = json.load(resp)
print(data["full_name"])
```

zsh
```zsh
curl -s -H "User-Agent: macadmin-script" "https://api.github.com/repos/python/cpython" | python3 -c 'import sys, json; print(json.load(sys.stdin)["full_name"])'
```

### Process inputted data (JSON, YAML)

Python
```python
import json
import yaml
import sys

payload = sys.stdin.read()
obj = json.loads(payload)
print(obj.get("name"))

with open("config.yml") as f:
    cfg = yaml.safe_load(f)
print(cfg.get("setting"))
```

zsh
```zsh
json='{"name":"macadmin"}'
name=$(printf '%s' "$json" | python3 -c 'import sys, json; print(json.load(sys.stdin)["name"])')
echo "$name"

# YAML requires an external parser on zsh
python3 -c 'import yaml, sys; print(yaml.safe_load(sys.stdin)["setting"])' < config.yml
```

---

## Files

### Finding a file

Python
```python
from pathlib import Path

for path in Path("/tmp").rglob("*.log"):
    print(path)
```

zsh
```zsh
find /tmp -name '*.log'
```

### Reading a file’s contents

Python
```python
from pathlib import Path

content = Path("/tmp/example.txt").read_text(encoding="utf-8")
print(content)
```

zsh
```zsh
cat /tmp/example.txt
```

### Copying or moving a file

Python
```python
from pathlib import Path
import shutil

src = Path("/tmp/source.txt")
dst = Path("/tmp/dest.txt")
shutil.copy2(src, dst)
shutil.move(dst, "/tmp/archive/source.txt")
```

zsh
```zsh
cp -p /tmp/source.txt /tmp/dest.txt
mv /tmp/dest.txt /tmp/archive/source.txt
```

### Editing a file

Python
```python
from pathlib import Path

path = Path("/tmp/config.conf")
text = path.read_text(encoding="utf-8")
text = text.replace("ENABLE=false", "ENABLE=true")
path.write_text(text, encoding="utf-8")
```

zsh
```zsh
sed -i '' 's/ENABLE=false/ENABLE=true/' /tmp/config.conf
```

### Modifying a file’s permissions

Python
```python
import os

os.chmod("/tmp/example.sh", 0o755)
```

zsh
```zsh
chmod 755 /tmp/example.sh
```

### Removing a file

Python
```python
from pathlib import Path

Path("/tmp/example.txt").unlink()
```

zsh
```zsh
rm /tmp/example.txt
```

### Creating a new file

Python
```python
from pathlib import Path

Path("/tmp/newfile.txt").write_text("Hello macadmins\n", encoding="utf-8")
```

zsh
```zsh
print "Hello macadmins" > /tmp/newfile.txt
```

---

## Advanced scripting

### Handling positional arguments

Python
```python
import sys

if len(sys.argv) < 2:
    print("Usage: script.py <user>")
    raise SystemExit(1)

target_user = sys.argv[1]
print(f"Target user: {target_user}")
```

zsh
```zsh
if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <user>"
  exit 1
fi

target_user="$1"
echo "Target user: $target_user"
```

### Functions

Python
```python
import subprocess


def install_pkg(pkg_path):
    subprocess.run(["installer", "-pkg", pkg_path, "-target", "/"], check=True)

install_pkg("/tmp/example.pkg")
```

zsh
```zsh
install_pkg() {
  local pkg_path="$1"
  sudo installer -pkg "$pkg_path" -target /
}

install_pkg "/tmp/example.pkg"
```

### Logging errors

Python
```python
import logging
import subprocess

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

try:
    subprocess.run(["false"], check=True)
except subprocess.CalledProcessError as exc:
    logger.error("Command failed: %s", exc)
    raise
```

zsh
```zsh
log_error() {
  echo "ERROR: $1" >&2
}

if ! false; then
  log_error "installer failed"
  exit 1
fi
```

### Prompting for missing data

Python
```python
import getpass
import sys

username = sys.argv[1] if len(sys.argv) > 1 else None
if not username:
    username = input("Enter username: ")
print(username)
```

zsh
```zsh
username=${1:-}
if [[ -z $username ]]; then
  read -r "username?Enter username: "
fi

echo "$username"
```

### While/for loops

Python
```python
for i in range(3):
    print(f"Iteration {i}")

count = 0
while count < 3:
    print(f"Count {count}")
    count += 1
```

zsh
```zsh
for i in {0..2}; do
  echo "Iteration $i"
done

count=0
while [[ $count -lt 3 ]]; do
  echo "Count $count"
  ((count++))
done
```

---

## Applied scripting

### LaunchAgents / LaunchDaemons

Python
```python
from pathlib import Path
import plistlib

plist = {
    "Label": "com.example.hello",
    "ProgramArguments": ["/usr/bin/python3", "/usr/local/bin/hello.py"],
    "RunAtLoad": True,
}
Path("~/Library/LaunchAgents/com.example.hello.plist").expanduser().write_bytes(plistlib.dumps(plist))
```

zsh
```zsh
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
```

### Jamf Extension Attributes (EA)

Python
```python
import subprocess
import plistlib

result = subprocess.run(["/usr/sbin/jamf", "policy", "-event", "myEA"], check=True, capture_output=True, text=True)
print(result.stdout)
```

zsh
```zsh
#!/bin/zsh
/usr/sbin/jamf policy -event myEA
```

### Munki install/uninstall/postinstall scripts

Python
```python
import subprocess
import sys

mode = sys.argv[1] if len(sys.argv) > 1 else "install"
if mode == "install":
    subprocess.run(["/usr/sbin/installer", "-pkg", "/tmp/MyApp.pkg", "-target", "/"], check=True)
elif mode == "uninstall":
    subprocess.run(["rm", "-rf", "/Applications/MyApp.app"], check=True)
else:
    print(f"Unknown mode: {mode}")
    raise SystemExit(1)
```

zsh
```zsh
#!/bin/zsh
mode=${1:-install}
if [[ $mode == install ]]; then
  /usr/sbin/installer -pkg "/tmp/MyApp.pkg" -target /
elif [[ $mode == uninstall ]]; then
  rm -rf "/Applications/MyApp.app"
else
  echo "Unknown mode: $mode"
  exit 1
fi
```

