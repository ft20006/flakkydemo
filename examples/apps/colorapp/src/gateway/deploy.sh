#!/usr/bin/env bash
# vim:syn=sh:ts=4:sw=4:et:ai

set -ex

# export AWS_ACCOUNT_ID=943999622203
# export AWS_DEFAULT_REGION=us-east-1
# export GATEWAY_ECR_REPO_NAME=gateway
# export GO_PROXY=direct

#aws ecr create-repository --repository-name=gateway
export COLOR_GATEWAY_IMAGE=$(aws ecr describe-repositories --repository-names=${GATEWAY_ECR_REPO_NAME} --query 'repositories[0].repositoryUri' --output text)

## run ./examples/apps/colorapp/src/gateway/deploy.sh

if [ -z $AWS_ACCOUNT_ID ]; then
    echo "AWS_ACCOUNT_ID environment variable is not set."
    exit 1
fi

if [ -z $AWS_DEFAULT_REGION ]; then
    echo "AWS_DEFAULT_REGION environment variable is not set."
    exit 1
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
ECR_URL="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com"
COLOR_GATEWAY_IMAGE=${COLOR_GATEWAY_IMAGE:-"${ECR_URL}/gateway"}
GO_PROXY=${GO_PROXY:-"https://proxy.golang.org"}
AWS_CLI_VERSION=$(aws --version 2>&1 | cut -d/ -f2 | cut -d. -f1)

ecr_login() {
    if [ $AWS_CLI_VERSION -gt 1 ]; then
        aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | \
            docker login --username AWS --password-stdin ${ECR_URL}
    else
        $(aws ecr get-login --no-include-email)
    fi
}

# build
docker build --build-arg GO_PROXY=$GO_PROXY -t $COLOR_GATEWAY_IMAGE ${DIR}

# push
ecr_login
docker push $COLOR_GATEWAY_IMAGE
