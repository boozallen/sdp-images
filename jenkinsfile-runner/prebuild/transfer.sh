#!/bin/bash

set -xe

# runs inside jenkins/jenkinsfile-runner
echo "+------------+"
echo "| Transfer   |"
echo "+------------+"

## transfer artifacts to dependencies dir
mkdir -p /root/prebuild/dependencies
cp -r /app /root/prebuild/dependencies/
mkdir -p /root/prebuild/dependencies/ref
mv /jenkinsfile-runner/target/plugins /root/prebuild/dependencies/ref/plugins