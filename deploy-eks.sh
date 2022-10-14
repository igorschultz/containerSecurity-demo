#!/bin/bash

# exit when any command fails
set -e

# Check if eksctl is installed.
if ! command -v eksctl &> /dev/null
then
    echo "eksctl could not be found. Install it following this: https://docs.aws.amazon.com/eks/latest/userguide/eksctl.html"
    exit
fi

eksctl create cluster \
    --tags Project=ReInforceContainerSecurityDemo \
    -t t3a.medium \
    --enable-ssm \
    --full-ecr-access \
    --alb-ingress-access