#!/bin/sh

export VERSION="3.5.16"
export IMAGE="ianburgwin/red-discordbot"
export BASEIMAGE="amd64/python:3.11-slim"

docker pull $BASEIMAGE
docker build --build-arg VERSION=$VERSION --build-arg BASEIMAGE=$BASEIMAGE --platform linux/amd64 -t $IMAGE - < redbot.dockerfile
docker tag $IMAGE $IMAGE:$VERSION
docker push $IMAGE
docker push $IMAGE:$VERSION
