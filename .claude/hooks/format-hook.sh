#!/usr/bin/env bash
# Hook: format-hook (post-Edit|Write)
# Formats Dart files after editing.
set -euo pipefail

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | python3 -c "import sys,json; print(json.load(sys.stdin)['tool_input']['file_path'])" 2>/dev/null || true)

if [[ -z "$FILE_PATH" ]]; then
  exit 0
fi

# Only format .dart files
if [[ "$FILE_PATH" != *.dart ]]; then
  exit 0
fi

# Skip generated files
if [[ "$FILE_PATH" == *.g.dart ]] || [[ "$FILE_PATH" == *.freezed.dart ]]; then
  exit 0
fi

# Format with project line length
dart format --line-length=120 "$FILE_PATH" 2>/dev/null || true

exit 0
