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

# PIPELINE_URL
# PIPELINE_REF

# Get pipeline url and ref from plugin config
PIPELINE_URL=$(echo "$BUILDKITE_PLUGINS" | jq -r '.[] | with_entries(select(.key|contains("hasura/smooth-checkout-buildkite-plugin")))[].repos[].config[].url' | sed 's/\.git//')
PIPELINE_REF=$(echo "$BUILDKITE_PLUGINS" | jq -r '.[] | with_entries(select(.key|contains("hasura/smooth-checkout-buildkite-plugin")))[].repos[].config[].ref' | sed 's/\.git//')

echo $PIPELINE_URL
echo $PIPELINE_REF

buildkite-agent annotate "Pipeline definition uploaded from our central repository: $PIPELINE_URL" --style 'info' --context 'ctx-pipeline-selector'
buildkite-agent annotate "Pipeline URL: $PIPELINE_URL" --style 'info' --context 'ctx-more'
buildkite-agent annotate "Pipeline REF: $PIPELINE_REF" --style 'info' --context 'ctx-more' --append

buildkite-agent pipeline upload $PIPELINE_FILE
