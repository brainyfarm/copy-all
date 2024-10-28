#!/bin/bash

generate_tree_structure() {
  local dir_path="$1"
  local prefix="$2"
  local depth="$3"
  [[ $MAX_DEPTH -ne 0 && $depth -ge $MAX_DEPTH ]] && return

  shopt -s nullglob
  $INCLUDE_HIDDEN && shopt -s dotglob

  local entries=( "$dir_path"/* )
  local count=${#entries[@]}
  local index=0

  for entry in "${entries[@]}"; do
    index=$((index + 1))
    [[ ! -e "$entry" ]] && continue
    is_ignored "$entry" && continue
    local connector="$SYM_TEE"
    [[ $index -eq $count ]] && connector="$SYM_ELBOW"
    local basename="$(basename "$entry")"
    echo "${prefix}${connector} ${basename}" >> "$OUTPUT_FILE"
    if [[ -d "$entry" ]]; then
      local new_prefix="$prefix"
      [[ $index -eq $count ]] && new_prefix+="    " || new_prefix+="│   "
      generate_tree_structure "$entry" "$new_prefix" $((depth + 1))
    fi
  done

  shopt -u dotglob
  shopt -u nullglob
}
