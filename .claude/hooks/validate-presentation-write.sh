#!/usr/bin/env bash
# Hook: validate-presentation-write (pre-Edit|Write)
# Blocks generated files and enforces presentation layer naming conventions.
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

# Validate presentation layer naming (controllers, pages)
if [[ "$FILE_PATH" == */presentation/controllers/* ]] && [[ "$FILE_PATH" == *.dart ]]; then
  BASENAME=$(basename "$FILE_PATH")
  # Skip barrel files and generated files
  if [[ "$BASENAME" != "controllers.dart" ]] && \
     [[ "$BASENAME" != *.g.dart ]] && \
     [[ "$BASENAME" != *.freezed.dart ]]; then
    if [[ "$BASENAME" != *_controller.dart ]] && [[ "$BASENAME" != *_providers.dart ]]; then
      echo "BLOCKED: Files in presentation/controllers/ must be named *_controller.dart or *_providers.dart."
      echo "Got: $BASENAME"
      exit 2
    fi
  fi
fi

if [[ "$FILE_PATH" == */presentation/pages/* ]] && [[ "$FILE_PATH" == *.dart ]]; then
  BASENAME=$(basename "$FILE_PATH")
  # Skip barrel files
  if [[ "$BASENAME" != "pages.dart" ]]; then
    if [[ "$BASENAME" != *_page.dart ]]; then
      echo "BLOCKED: Files in presentation/pages/ must be named *_page.dart."
      echo "Got: $BASENAME"
      exit 2
    fi
  fi
fi

exit 0
