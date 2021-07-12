#!/bin/bash

set -ex 

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

aws --profile "${AWS_PROFILE}" --region "${AWS_DEFAULT_REGION}" \
    cloudformation deploy \
    --stack-name "${ENVIRONMENT_NAME}-eks-cluster" \
    --capabilities CAPABILITY_IAM \
    --template-file "${DIR}/eks-cluster.yaml"  \
    --parameter-overrides \
    EnvironmentName="${ENVIRONMENT_NAME}" \
    KeyName="${KEY_PAIR_NAME}" \
    NodeInstanceRole="${NODE_INSTANCE_ROLE}" \
    ECSInstanceRole="${ECS_INSTANCE_ROLE}" \
    AWSServiceRoleForAmazonEKS="${AWS_SERVICES_ROLE_AMAZON_EKS}"