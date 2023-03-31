#!/bin/bash

set -euo pipefail

# TODO
# Error handling and instructions when no project dir or pipeline is found in the control repository

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
echo -e "This [pipeline definition]($REMOTE_PIPELINE_FILE) is managed by the Platform Team.  \nFor further information see the [README]($PIPELINE_URL) or [contact us](https://www.google.com/)." | buildkite-agent annotate --style 'info' --context 'ctx-remote-pipeline-definition'

# Upload pipeline
buildkite-agent pipeline upload $LOCAL_PIPELINE_PATH
