#!/bin/bash

set -euo pipefail

ls -la
ls -la ./pipelines
echo "$BUILDKITE_REPO"
echo "$BUILDKITE_REPO" | sed 's|.*/||'
echo "$BUILDKITE_REPO" | cut -d / -f 4-
MYVAR=$(echo "$BUILDKITE_REPO" | sed 's|.*/||')
echo $MYVAR
