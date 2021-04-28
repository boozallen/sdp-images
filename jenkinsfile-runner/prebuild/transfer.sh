#!/bin/bash

set -xe

mkdir -p /root/prebuild/dependencies

cp -r /app /root/prebuild/dependencies/
cp -r /usr/share/jenkins/ref /root/prebuild/dependencies/
