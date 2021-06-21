#!/bin/bash

set -xe

## runs inside registry.access.redhat.com/ubi8/ubi:8.4
echo "+------------+"
echo "| Bulid Dep  |"
echo "+------------+"

SDP_BUILD_DEPENDENCY_VERSION=dcar-1.8

cd /root/prebuild
tar czvf jenkinsfile-runner-dependencies-$SDP_BUILD_DEPENDENCY_VERSION.tar.gz dependencies
gpg --import /root/prebuild/BAH-public.key
gpg --import --allow-secret-key-import  /root/prebuild/BAH-private.key
gpg --output /root/prebuild/jenkinsfile-runner-dependencies-$SDP_BUILD_DEPENDENCY_VERSION.sig --detach-sig /root/prebuild/jenkinsfile-runner-dependencies-$SDP_BUILD_DEPENDENCY_VERSION.tar.gz
sha256sum /root/prebuild/jenkinsfile-runner-dependencies-$SDP_BUILD_DEPENDENCY_VERSION.tar.gz | awk '{print $1}' > /root/prebuild/jenkinsfile-runner-dependencies-$SDP_BUILD_DEPENDENCY_VERSION.sha256
rm -rf /root/prebuild/dependencies
