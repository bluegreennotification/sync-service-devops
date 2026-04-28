#!/bin/bash

ENV=$1
IMAGE=$2

echo "Deploying to $ENV with image $IMAGE"

kubectl set image deployment/sync-service \
  sync-service=$IMAGE \
  --namespace=$ENV

kubectl rollout status deployment/sync-service -n $ENV
