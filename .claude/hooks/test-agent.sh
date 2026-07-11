#!/usr/bin/env bash
# Hook: test-agent
# Runs Flutter tests with compact reporter and fail-fast.
set -euo pipefail

TEST_PATH="${1:-test}"

fvm flutter test --reporter=compact --fail-fast "$TEST_PATH"
