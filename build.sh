#!/bin/bash
set -e

ENV=$1

if [ -z "$ENV" ]; then
  echo "Usage: ./build.sh staging|production"
  exit 1
fi

if [ "$ENV" = "staging" ]; then
  REGISTRY="gcr.io/chataai-public/staging-gcp-marketplace"
  TAG="1.1.1-gcp.alpha1"
  VERSION="1.1.1-gcp.alpha1"
  PUBLISHED_VERSION="1.1.1-gcp.alpha1"
  SERVICE_NAME="autoql-by-chata2-staging.endpoints.chataai-public.cloud.goog"

elif [ "$ENV" = "production" ]; then
  REGISTRY="gcr.io/chataai-public/gcp-marketplace"
  TAG="1.1.1-gmp1"
  VERSION="1.1.1-gmp1"
  PUBLISHED_VERSION="1.1.1-gmp1"
  SERVICE_NAME="autoql-by-chata2.endpoints.chataai-public.cloud.goog"

else
  echo "Invalid env. Use staging or production"
  exit 1
fi

echo "Building for: $ENV"

docker buildx build \
  --platform linux/amd64 \
  --provenance=false \
  --build-arg REGISTRY=$REGISTRY \
  --build-arg TAG=$TAG \
  --build-arg VERSION=$VERSION \
  --build-arg PUBLISHED_VERSION=$PUBLISHED_VERSION \
  --build-arg SERVICE_NAME=$SERVICE_NAME \
  -t $REGISTRY/deployer:$VERSION \
  --push \
  .

  crane mutate $REGISTRY/deployer:$VERSION \
  --platform linux/amd64 \
  --annotation "com.googleapis.cloudmarketplace.product.service.name=services/$SERVICE_NAME" \
  --tag $REGISTRY/deployer:$VERSION


