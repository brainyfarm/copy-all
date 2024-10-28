#!/bin/bash

log_info() {
  $VERBOSE && echo "[INFO] $1"
}

log_error() {
  echo "[ERROR] $1" >&2
}

trim() {
  local var="$*"
  var="${var#"${var%%[![:space:]]*}"}"
  var="${var%"${var##*[![:space:]]}"}"
  echo -n "$var"
}

print_help() {
  cat << EOF
Usage: copyall [options]

Options:
  -f, --folders            Comma-separated list of folders to include.
  --file-types             Comma-separated list of file types to include.
  --ignore-tests           Exclude test files and directories.
  --src-only               Only include the 'src' folder.
  --remove-comments        Remove comments from code files.
  --summary-lines <number> Number of lines for file summaries (0 for full).
  --max-file-size <bytes>  Maximum file size in bytes for processing.
  --include-hidden         Include hidden files and directories.
  --max-depth <number>     Maximum depth for directory traversal.
  --verbose                Enable verbose output.
  -h, --help               Display help.
EOF
}

parse_arguments() {
  while [[ $# -gt 0 ]]; do
    case $1 in
      -f|--folders)
        FOLDERS="$2"
        shift 2
        ;;
      --file-types)
        FILE_TYPES="$2"
        shift 2
        ;;
      --ignore-tests)
        IGNORE_TESTS=true
        shift
        ;;
      --src-only)
        SRC_ONLY=true
        shift
        ;;
      --remove-comments)
        REMOVE_COMMENTS=true
        shift
        ;;
      --summary-lines)
        SUMMARY_LINES="$2"
        shift 2
        ;;
      --max-file-size)
        MAX_FILE_SIZE="$2"
        shift 2
        ;;
      --include-hidden)
        INCLUDE_HIDDEN=true
        shift
        ;;
      --max-depth)
        MAX_DEPTH="$2"
        shift 2
        ;;
      --verbose)
        VERBOSE=true
        shift
        ;;
      -h|--help)
        print_help
        exit 0
        ;;
      *)
        echo "Unknown option: $1"
        print_help
        exit 1
        ;;
    esac
  done
}

setup_environment() {
  mkdir -p "$COPYALL_DIR"
  : > "$OUTPUT_FILE"
  log_info "Environment setup completed."

  if [[ -f "$GITIGNORE_FILE" ]]; then
    if ! grep -qxF "copyall/" "$GITIGNORE_FILE"; then
      echo -e "\ncopyall/" >> "$GITIGNORE_FILE"
      log_info "Added 'copyall/' to .gitignore."
    fi
  else
    echo "copyall/" > "$GITIGNORE_FILE"
    log_info "Created .gitignore and added 'copyall/'."
  fi
}

finalize_execution() {
  local end_time
  end_time=$(date +%s)
  local duration=$((end_time - START_TIME))
  log_info "CopyAll process completed in $duration seconds."

  if [[ -n "$CLIP_CMD" ]]; then
    cat "$OUTPUT_FILE" | eval "$CLIP_CMD"
    log_info "Output copied to clipboard."
  else
    log_info "Clipboard command not found. Output not copied to clipboard."
  fi

  local file_count
  file_count=$(grep -c "^--- Contents of " "$OUTPUT_FILE")
  echo "Processed $file_count files in $duration seconds."
}
