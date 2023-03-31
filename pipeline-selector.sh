#!/bin/bash

set -euo pipefail

# ls -la
# ls -la ./pipelines
echo "BUILDKITE_REPO is $BUILDKITE_REPO"
echo "$BUILDKITE_REPO" | sed 's|.*/||'
PIPELINE_DIR=$(echo "$BUILDKITE_REPO" | cut -d / -f 4- | sed 's/\.git//')
echo "PIPELINE_DIR is $PIPELINE_DIR"
FULL_PIPELINE_DIR="./pipelines/$PIPELINE_DIR"
echo "FULL_PIPELINE_DIR is $FULL_PIPELINE_DIR"
ls -l $FULL_PIPELINE_DIR
PIPELINE_FILE="$FULL_PIPELINE_DIR/pipeline.yaml"
echo "PIPELINE_FILE is $PIPELINE_FILE"

# Get base repository from plugin config
PIPELINE_REPO=$(echo "$BUILDKITE_PLUGINS" | jq -r '.[] | with_entries(select(.key|contains("hasura/smooth-checkout-buildkite-plugin")))[].repos[].config[].url' | sed 's/\.git//')
echo $PIPELINE_REPO

buildkite-agent annotate "Pipeline definition uploaded from our central repository: $BUILDKITE_REPO" --style 'info' --context 'ctx-pipeline-selector'
buildkite-agent annotate " $PIPELINE_REPO" --style 'info' --context 'ctx-more'

buildkite-agent pipeline upload $PIPELINE_FILE
