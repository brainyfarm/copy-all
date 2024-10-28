#!/bin/bash

get_file_size() {
  local file="$1"
  if [[ "$OSTYPE" == "darwin"* ]]; then
    stat -f%z "$file"
  else
    stat -c%s "$file"
  fi
}

is_allowed_file_type() {
  [[ -z "$FILE_TYPES" ]] && return 0
  local file_ext="${1##*.}"
  IFS=',' read -ra types <<< "$FILE_TYPES"
  for type in "${types[@]}"; do
    if [[ "$file_ext" == "$type" ]]; then
      return 0
    fi
  done
  return 1
}

remove_comments() {
  local file="$1"
  local extension="${file##*.}"
  case "$extension" in
    sh|bash)
      sed '/^\s*#/d;/^\s*$/d' "$file"
      ;;
    py)
      sed '/^\s*#/d;/^\s*$/d' "$file"
      ;;
    *)
      cat "$file"
      ;;
  esac
}

process_file() {
  local file="$1"
  local depth="$2"

  local file_size
  file_size=$(get_file_size "$file")
  if [[ $file_size -gt $MAX_FILE_SIZE ]]; then
    log_info "Skipping $file due to size limit."
    return
  fi

  if ! is_allowed_file_type "$file"; then
    return
  fi

  if $VERBOSE; then
    log_info "Processing $file"
  fi

  echo "--- Contents of ${file#$ROOT_DIR/} ---" >> "$OUTPUT_FILE"

  if $REMOVE_COMMENTS; then
    if [[ $SUMMARY_LINES -gt 0 ]]; then
      remove_comments "$file" | head -n "$SUMMARY_LINES" >> "$OUTPUT_FILE"
    else
      remove_comments "$file" >> "$OUTPUT_FILE"
    fi
  else
    if [[ $SUMMARY_LINES -gt 0 ]]; then
      head -n "$SUMMARY_LINES" "$file" >> "$OUTPUT_FILE"
    else
      cat "$file" >> "$OUTPUT_FILE"
    fi
  fi
}

output_file_contents() {
  local dir_path="$1"
  local depth="$2"
  [[ $MAX_DEPTH -ne 0 && $depth -ge $MAX_DEPTH ]] && return

  shopt -s nullglob
  $INCLUDE_HIDDEN && shopt -s dotglob

  local files=( "$dir_path"/* )
  for file in "${files[@]}"; do
    [[ ! -e "$file" ]] && continue
    is_ignored "$file" && continue
    if [[ -f "$file" ]]; then
      process_file "$file" "$depth"
    elif [[ -d "$file" ]]; then
      output_file_contents "$file" $((depth + 1))
    fi
  done

  shopt -u dotglob
  shopt -u nullglob
}
