#!/bin/bash

set -ex

export AWS_PROFILE=default
export AWS_DEFAULT_REGION=us-east-1
export ENVIRONMENT_NAME=DEMO

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

aws --profile "${AWS_PROFILE}" --region "${AWS_DEFAULT_REGION}" \
    cloudformation deploy \
    --stack-name "Container-IRAD-Task2-Roles" \
    --capabilities CAPABILITY_IAM \
    --template-file "${DIR}/role-template.yaml"