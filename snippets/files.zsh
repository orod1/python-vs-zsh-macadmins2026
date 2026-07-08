#!/bin/zsh
# File operations in zsh.

# Find matching files in a directory tree.
find_files() {
  local root="$1"
  local pattern="$2"
  find "$root" -name "$pattern"
}

# Print the contents of a file to stdout.
read_file() {
  local path="$1"
  cat "$path"
}

# Copy a file while preserving permissions and timestamps.
copy_file() {
  local source="$1"
  local destination="$2"
  cp -p "$source" "$destination"
}

# Move or rename a file.
move_file() {
  local source="$1"
  local destination="$2"
  mv "$source" "$destination"
}

# Replace text in a file using sed.
edit_file() {
  local path="$1"
  local old_text="$2"
  local new_text="$3"
  sed -i '' "s/$old_text/$new_text/" "$path"
}

# Change the mode on a file.
chmod_file() {
  local path="$1"
  local mode="$2"
  chmod "$mode" "$path"
}

# Delete the specified file.
remove_file() {
  local path="$1"
  rm "$path"
}

# Create a file and write a line of text into it.
create_file() {
  local path="$1"
  local contents="$2"
  print -- "$contents" > "$path"
}

echo "Find logs:"
find_files /tmp '*.log'
