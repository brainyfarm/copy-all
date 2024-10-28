# CopyAll

CopyAll is a customizable file copying script that generates a directory tree and outputs file contents based on specified options. It also copies the output to your clipboard.

## Features

- Include or exclude specific folders.
- Filter files by type.
- Ignore test files and directories.
- Option to process only the `src` folder.
- Remove comments from code files.
- Limit the number of lines in file summaries.
- Set maximum file size for processing.
- Include hidden files and directories.
- Control the maximum depth for directory traversal.
- Verbose output and progress indicators.
- **New:** Copies the output to clipboard.
- Overwrites the output file instead of appending.
- Automatically ignores files and directories specified in `.gitignore` and `.copyallignore`.

## Usage

```bash
copyall [options]
```

## Options
-f, --folders : Comma-separated list of folders to include.
--file-types : Comma-separated list of file types to include.
--ignore-tests : Exclude test files and directories.
--src-only : Only include the 'src' folder.
--remove-comments : Remove comments from code files.
--summary-lines <number> : Number of lines for file summaries (0 for full).
--max-file-size <bytes> : Maximum file size in bytes for processing.
--include-hidden : Include hidden files and directories.
--max-depth <number> : Maximum depth for directory traversal.
--verbose : Enable verbose output.
-h, --help : Display help.
Examples
bash
Copy code
# Copy all files in 'src' folder and copy output to clipboard
copyall --src-only

# Copy files with specific file types
copyall --file-types sh,md

# Include hidden files and limit depth
copyall --include-hidden --max-depth 2
makefile
Copy code
---


