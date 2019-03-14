#!/bin/bash

set -xe

IMAGE=registry-vpc.cn-shanghai.aliyuncs.com/shuzhi/code_server

docker build -t ${IMAGE}:$1 . -f ./docker/Dockerfile ${@:2}

docker tag ${IMAGE}:$1 ${IMAGE}:latest

docker push ${IMAGE}:$1
docker push ${IMAGE}:latest
