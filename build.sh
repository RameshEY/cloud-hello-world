#!/bin/bash

$(aws ecr get-login --region eu-central-1)
/usr/bin/apache-maven-3.3.9/bin/mvn package
tag=$(git describe --abbrev=0 --tags)
docker build -t hello-world:$tag .
docker tag hello-world:$tag 156161676080.dkr.ecr.eu-central-1.amazonaws.com/hello-world:$tag
docker tag hello-world:$tag 156161676080.dkr.ecr.eu-central-1.amazonaws.com/hello-world:latest

docker push 156161676080.dkr.ecr.eu-central-1.amazonaws.com/hello-world:$tag
docker push 156161676080.dkr.ecr.eu-central-1.amazonaws.com/hello-world:latest