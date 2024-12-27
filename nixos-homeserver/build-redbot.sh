#!/bin/sh

export VERSION="3.5.13"
export IMAGE="ianburgwin/red-discordbot"

docker build --build-arg VERSION=$VERSION --platform linux/amd64 -t $IMAGE - < redbot.dockerfile
docker tag $IMAGE $IMAGE:$VERSION
docker push $IMAGE
docker push $IMAGE:$VERSION
