#!/bin/bash

set -euo pipefail

# ls -la
# ls -la ./pipelines
# echo "BUILDKITE_REPO is $BUILDKITE_REPO"
# echo "$BUILDKITE_REPO" | sed 's|.*/||'
PIPELINE_DIR=$(echo "$BUILDKITE_REPO" | cut -d / -f 4- | sed 's/.git//')
# echo "PIPELINE_DIR is $PIPELINE_DIR"
FULL_PIPELINE_DIR="./pipelines/$PIPELINE_DIR"
# echo "FULL_PIPELINE_DIR is $FULL_PIPELINE_DIR"
# ls -l $FULL_PIPELINE_DIR
PIPELINE_FILE="$FULL_PIPELINE_DIR/pipeline.yaml"
# echo "PIPELINE_FILE is $PIPELINE_FILE"

# echo "$BUILDKITE_PLUGINS" | jq '.'

echo "$BUILDKITE_PLUGINS" | jq -r '.[] | with_entries(select(.key|contains("hasura/smooth-checkout-buildkite-plugin")))[].repos[].config[].url'

PIPELINE_REPO=$(echo "$BUILDKITE_PLUGINS" | jq -r '.[] | with_entries(select(.key|contains("hasura/smooth-checkout-buildkite-plugin")))[].repos[].config[].url')
echo $PIPELINE_REPO

PIPELINE_REPO_CUT=$(echo "$PIPELINE_REPO" | sed 's/.git//')

# .[] | with_entries( select(.key|contains("hasura/smooth-checkout-buildkite-plugin")))

buildkite-agent annotate "Pipeline definition uploaded from our central repository: $BUILDKITE_REPO" --style 'info' --context 'ctx-pipeline-selector'
buildkite-agent annotate " $PIPELINE_REPO_CUT" --style 'info' --context 'ctx-more'

buildkite-agent pipeline upload $PIPELINE_FILE
