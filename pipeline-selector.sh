#!/bin/bash

set -euo pipefail

# Get project repository
PIPELINE_FILENAME='pipeline.yaml'
PIPELINE_ORG_REPO=$(echo "$BUILDKITE_REPO" | cut -d / -f 4- | sed 's/\.git$//')

# Construct local pipeline file path
LOCAL_PIPELINE_PATH="./pipelines/$PIPELINE_ORG_REPO/$PIPELINE_FILENAME"
echo "PIPELINE_ORG_REPO is $PIPELINE_ORG_REPO"
echo "PIPELINE_FILENAME is $PIPELINE_FILENAME"
echo "LOCAL_PIPELINE_PATH is $LOCAL_PIPELINE_PATH"

# Get pipeline url and ref from plugin config
PIPELINE_URL=$(echo "$BUILDKITE_PLUGINS" | jq -r '.[] | with_entries(select(.key|contains("hasura/smooth-checkout-buildkite-plugin")))[].repos[].config[].url' | sed 's/\.git$//')
PIPELINE_REF=$(echo "$BUILDKITE_PLUGINS" | jq -r '.[] | with_entries(select(.key|contains("hasura/smooth-checkout-buildkite-plugin")))[].repos[].config[].ref' | sed 's/\.git$//')
echo "PIPELINE_URL is $PIPELINE_URL"
echo "PIPELINE_REF is $PIPELINE_REF"

# Construct remote pipeline url
REMOTE_PIPELINE_FILE="$PIPELINE_URL/tree/$PIPELINE_REF/pipelines/$PIPELINE_ORG_REPO/pipeline.yaml"
echo "REMOTE_PIPELINE_FILE is $REMOTE_PIPELINE_FILE"

# Create annotation
echo -e "Pipeline Definition [here]('$REMOTE_PIPELINE_FILE') or [here](\"$REMOTE_PIPELINE_FILE\") or [here]($REMOTE_PIPELINE_FILE) : $REMOTE_PIPELINE_FILE  \nPipeline URL: $PIPELINE_URL  \nPipeline REF: \`$PIPELINE_REF\`" | buildkite-agent annotate --style 'info' --context 'ctx-more2'

# Upload pipeline
buildkite-agent pipeline upload $LOCAL_PIPELINE_PATH
