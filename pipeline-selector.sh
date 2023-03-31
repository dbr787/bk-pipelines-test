#!/bin/bash

set -euo pipefail

ls -la
ls -la ./pipelines
echo "BUILDKITE_REPO is $BUILDKITE_REPO"
# echo "$BUILDKITE_REPO" | sed 's|.*/||'
PIPELINE_DIR=$(echo "$BUILDKITE_REPO" | cut -d / -f 4-)
echo "PIPELINE_DIR is $PIPELINE_DIR"
FULL_PIPELINE_DIR="./pipelines/$PIPELINE_DIR"
echo "FULL_PIPELINE_DIR is $FULL_PIPELINE_DIR"
ls -l $FULL_PIPELINE_DIR
PIPELINE_FILE="$FULL_PIPELINE_DIR/pipeline.yaml"
echo "PIPELINE_FILE is $PIPELINE_FILE"

buildkite-agent pipeline upload pipeline.yaml
