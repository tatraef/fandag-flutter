#!/usr/bin/env bash
# Hook: validate-data-write (pre-Edit|Write)
# Blocks generated files and enforces data layer conventions.
set -euo pipefail

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | python3 -c "import sys,json; print(json.load(sys.stdin)['tool_input']['file_path'])" 2>/dev/null || true)

if [[ -z "$FILE_PATH" ]]; then
  exit 0
fi

# Block generated files
if [[ "$FILE_PATH" == *.g.dart ]] || [[ "$FILE_PATH" == *.freezed.dart ]]; then
  echo "BLOCKED: Do not manually edit generated files (*.g.dart, *.freezed.dart)."
  echo "Run 'make gen' instead."
  exit 2
fi

# Ensure test files go under test/
if [[ "$FILE_PATH" == *_test.dart ]] && [[ "$FILE_PATH" != test/* ]]; then
  echo "BLOCKED: Test files must be placed under test/, not in lib/."
  exit 2
fi

exit 0
