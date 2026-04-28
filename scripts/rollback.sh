#!/bin/bash

set -e

ENV=$1
DEPLOYMENT=${2:-sync-service}

if [ -z "$ENV" ]; then
  echo "Usage: ./rollback.sh <environment> [deployment-name]"
  exit 1
fi

echo "Rolling back deployment: $DEPLOYMENT in namespace: $ENV"

# Check if deployment exists
if ! kubectl get deployment $DEPLOYMENT -n $ENV >/dev/null 2>&1; then
  echo "Deployment $DEPLOYMENT not found in namespace $ENV"
  exit 1
fi

# Perform rollback
kubectl rollout undo deployment/$DEPLOYMENT -n $ENV

# Wait for rollout status
echo "Waiting for rollback to complete..."
kubectl rollout status deployment/$DEPLOYMENT -n $ENV

echo "Rollback completed successfully"

