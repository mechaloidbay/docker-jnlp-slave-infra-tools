#!/bin/bash

# Verify labels - docker image inspect jenkins-master-base | jq -r '.[0].Config.Labels'
SERVICE_NAME=jnlp-slave-sandbox
DO_DOCKER_LOGIN="1"
VERBOSE="0"
DRY_RUN="0"
DO_GIT_TAG="0"
BASE_TAG=""
NAMESPACE=""

while true; do
  case "$1" in
    -v | --verbose ) VERBOSE="1"; shift ;;
    -n | --dry-run ) DRY_RUN="1"; shift ;;
    -g | --git-tag ) DO_GIT_TAG="1"; shift ;;
    --skip-login ) DO_DOCKER_LOGIN="0"; shift ;;
    -r | --registry ) REGISTRY="$2"; shift; shift ;;
    -n | --namespace ) NAMESPACE="$2"; shift; shift ;;
    -t | --tag ) BASE_TAG="$2"; shift; shift ;;
    -- ) shift; break ;;
    * ) break ;;
  esac
done

# If tag is empty, set it to latest
if [ -z "$BASE_TAG" ];
then
    BASE_TAG="latest"
fi
TAG=":"$BASE_TAG


# If namespace is not empty, set it to latest
if [ -z "$NAMESPACE" ];
then
    NAMESPACE=""
else
    NAMESPACE="/"$NAMESPACE"/"
fi

DATE_TIME=`date '+%Y%m%d%H%M%S'`
COMMIT_ID=$(git rev-parse HEAD)

if [ "$VERBOSE" -eq "1" ];
then
    echo VERBOSE=$VERBOSE
    echo DO_DOCKER_LOGIN=$DO_DOCKER_LOGIN
    echo REGISTRY=$REGISTRY
    echo NAMESPACE=$NAMESPACE
    echo TAG=$TAG
    echo DATE_TIME=$DATE_TIME
    echo COMMIT_ID=$COMMIT_ID
fi

if [ "$DRY_RUN" -eq "0" ];
then
    # docker registry login
    if [ "$DO_DOCKER_LOGIN" -eq "1" ];
    then
       docker login $REGISTRY
    fi

    DOCKER_REGISTRY_URL=$REGISTRY DOCKER_REGISTRY_NAMESPACE=$NAMESPACE IMAGE_TAG=$TAG TIMESTAMP=$DATE_TIME COMMIT_ID=$COMMIT_ID docker-compose build

    DOCKER_REGISTRY_URL=$REGISTRY DOCKER_REGISTRY_NAMESPACE=$NAMESPACE IMAGE_TAG=$TAG TIMESTAMP=$DATE_TIME COMMIT_ID=$COMMIT_ID docker-compose push $SERVICE_NAME

    if [ "$DO_GIT_TAG" -eq "1" ];
    then
        git tag $TAG
        git push origin $TAG
    fi
fi