#!/bin/sh

# Exit on error
set -e
# Verbose output of cmds
# set -x

SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CONFIG="$(cd "$(dirname "$1")"; pwd)/$(basename "$1")"

alias jenkins-jobs="docker run --env PYTHONHTTPSVERIFY=0 --privileged --rm -v $SCRIPTS_DIR/..:$SCRIPTS_DIR/.. docker-registry.engineering.redhat.com/mobile/jenkins-job-builder:latest jenkins-jobs"

generate_inline_script_job() {
  $SCRIPTS_DIR/generate_inline_script_pipeline_job -j $1 -o $SCRIPTS_DIR/../jobs/generated
}

rm -rf $SCRIPTS_DIR/../jobs/generated/*

#Delorean Jobs
generate_inline_script_job $SCRIPTS_DIR/../jobs/delorean/misc/github-events/github-events.yaml
generate_inline_script_job $SCRIPTS_DIR/../jobs/delorean/sample-product/ga/discovery.yaml
generate_inline_script_job $SCRIPTS_DIR/../jobs/delorean/sample-product/ga/branch.yaml

#Delorean Folders
jenkins-jobs --conf $CONFIG update $SCRIPTS_DIR/../jobs/delorean/folders.yaml

#Generated jobs
jenkins-jobs --conf $CONFIG update $SCRIPTS_DIR/../jobs/generated/

#Views
jenkins-jobs --conf $CONFIG update $SCRIPTS_DIR/../views/delorean/
