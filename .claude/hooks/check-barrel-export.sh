#!/usr/bin/env bash
# Hook: check-barrel-export (post-Edit|Write)
# Warns if a new Dart file is not exported from its sub-barrel.
set -euo pipefail

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | python3 -c "import sys,json; print(json.load(sys.stdin)['tool_input']['file_path'])" 2>/dev/null || true)

[[ -z "$FILE_PATH" ]] && exit 0
[[ "$FILE_PATH" != *.dart ]] && exit 0

# Skip generated files
BASENAME=$(basename "$FILE_PATH")
[[ "$BASENAME" == *.g.dart ]] && exit 0
[[ "$BASENAME" == *.freezed.dart ]] && exit 0

# Skip test files
[[ "$FILE_PATH" == */test/* ]] && exit 0

# Skip core files (core uses flat barrels, not two-level)
[[ "$FILE_PATH" == */core/* ]] && exit 0

# Only check feature files
[[ "$FILE_PATH" != */features/* ]] && exit 0

# Skip barrel files themselves (e.g. entities/entities.dart, domain.dart)
DIR=$(dirname "$FILE_PATH")
DIR_NAME=$(basename "$DIR")
[[ "$BASENAME" == "$DIR_NAME.dart" ]] && exit 0

# Skip layer barrels (domain.dart, data.dart, presentation.dart)
[[ "$BASENAME" == "domain.dart" ]] && exit 0
[[ "$BASENAME" == "data.dart" ]] && exit 0
[[ "$BASENAME" == "presentation.dart" ]] && exit 0

# Find sub-barrel: same directory, named after the directory
BARREL="$DIR/$DIR_NAME.dart"
if [[ -f "$BARREL" ]]; then
  if ! grep -q "export '$BASENAME';" "$BARREL"; then
    echo "WARNING: $BASENAME is not exported from $DIR_NAME.dart"
    echo "Add to $BARREL:"
    echo "  export '$BASENAME';"
  fi
fi

exit 0
