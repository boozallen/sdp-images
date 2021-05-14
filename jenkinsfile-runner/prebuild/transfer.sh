#!/bin/bash

set -xe

# runs inside jenkins/jenkinsfile-runner
echo "+------------+"
echo "| Transfer   |"
echo "+------------+"

## transfer artifacts to dependencies dir
mkdir -p /root/prebuild/dependencies /root/prebuild/dependencies/ref
cp -r /app /root/prebuild/dependencies/
cp -r /jenkinsfile-runner/target/plugins /root/prebuild/dependencies/ref/plugins
