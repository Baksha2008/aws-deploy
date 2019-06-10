#!/bin/bash -e

# the registry should have been created already
# you could just paste a given url from AWS but I'm
# parameterising it to make it more obvious how its constructed
REGISTRY_URL=${AWS_ACCOUNT_ID}.dkr.ecr.us-east-2.amazonaws.com
# this is most likely namespaced repo name like myorg/veryimportantimage
SOURCE_IMAGE="test:latest"
# using it as there will be 2 versions published
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

aws ecs update-service \
  --cluster my-cluster-name \
  --service web \
  --task-definition test \
  --force-new-deployment