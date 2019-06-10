#!/bin/bash -e

REGISTRY_URL=${AWS_ACCOUNT_ID}.dkr.ecr.us-east-2.amazonaws.com
SOURCE_IMAGE="test:latest"
TARGET_IMAGE="${REGISTRY_URL}/test:latest"

# Push image to ECR
###################

# I'm speculating it obtains temporary access token
# it expects aws access key and secret set
# in environmental vars
$(aws ecr get-login --no-include-email --region us-east-2)

# update latest version
docker tag ${SOURCE_IMAGE} ${TARGET_IMAGE}
docker push ${TARGET_IMAGE}

# update service and task
aws ecs update-service --cluster test --service blablabla --task-definition test --force-new-deployment