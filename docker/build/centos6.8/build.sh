#!/bin/bash

TAG=yongtao/centos6
VERSION="latest"

cmd="docker build -t $TAG:$VERSION ."

echo "RUNNING: $cmd"

$cmd
exit $?
