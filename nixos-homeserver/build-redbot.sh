#!/usr/bin/env bash

set -xe

curdir=$(dirname "$0")
infofile=$curdir/redbot-info.json

echo "Info file: $infofile"

export VERSION=$(jq -r .version < "$infofile")
export IMAGE=$(jq -r .imagename < "$infofile")
export BASEIMAGE=$(jq -r .baseimage < "$infofile")

docker pull $BASEIMAGE
docker build --build-arg VERSION=$VERSION --build-arg BASEIMAGE=$BASEIMAGE --platform linux/amd64 -t $IMAGE - < "$curdir/redbot.dockerfile"
docker tag $IMAGE $IMAGE:$VERSION
docker push $IMAGE
docker push $IMAGE:$VERSION
