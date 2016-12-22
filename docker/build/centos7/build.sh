#!/bin/bash

TAG=yongtao/centos7
VERSION="latest"

cmd="docker build --rm --no-cache -t $TAG:$VERSION ."

echo "RUNNING: $cmd"

$cmd
exit $?
