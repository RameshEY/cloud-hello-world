#!/bin/bash

tag=$(git describe --abbrev=0 --tags)
sed -i '' 's/{RELEASE}/${tag}/g' src/main/resources/application-*
mvn package

docker build -f build/Dockerfile -t hello-world:$tag .

$(aws ecr get-login --region eu-central-1)
docker tag hello-world:$tag 156161676080.dkr.ecr.eu-central-1.amazonaws.com/hello-world:$tag
docker tag hello-world:$tag 156161676080.dkr.ecr.eu-central-1.amazonaws.com/hello-world:latest

docker push 156161676080.dkr.ecr.eu-central-1.amazonaws.com/hello-world:$tag
docker push 156161676080.dkr.ecr.eu-central-1.amazonaws.com/hello-world:latest

docker rmi hello-world:$tag
docker rmi 156161676080.dkr.ecr.eu-central-1.amazonaws.com/hello-world:$tag