#!/bin/bash

set -euo pipefail

ls -la
ls -la ./pipelines
echo "BUILDKITE_REPO is $BUILDKITE_REPO"
# echo "$BUILDKITE_REPO" | sed 's|.*/||'
# echo "$BUILDKITE_REPO" | cut -d / -f 4-
PIPELINE_DIR=$(echo "$BUILDKITE_REPO" | cut -d / -f 4-)
echo "PIPELINE_DIR is $BUILDKITE_REPO"
# echo $PIPELINE_DIR
