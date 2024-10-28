#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/config.sh"
source "$SCRIPT_DIR/utils.sh"
source "$SCRIPT_DIR/ignore_handler.sh"
source "$SCRIPT_DIR/file_operations.sh"
source "$SCRIPT_DIR/tree_structure.sh"

main() {
  parse_arguments "$@"
  setup_environment
  add_to_ignore_files
  load_ignored_files
  generate_tree_structure "$ROOT_DIR" "" 0
  output_file_contents "$ROOT_DIR" 0
  finalize_execution
}

main "$@"
