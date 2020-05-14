#!/bin/bash

set -xe

SDP_BUILD_DEPENDENCY_VERSION=dcar-1.1

cd /root/prebuild 
tar czvf jenkins-dependencies-$SDP_BUILD_DEPENDENCY_VERSION.tar.gz dependencies
gpg --import /root/prebuild/BAH-public.key
gpg --import --allow-secret-key-import  /root/prebuild/BAH-private.key
gpg --output /root/prebuild/jenkins-dependencies-$SDP_BUILD_DEPENDENCY_VERSION.sig --detach-sig /root/prebuild/jenkins-dependencies-$SDP_BUILD_DEPENDENCY_VERSION.tar.gz
sha256sum /root/prebuild/jenkins-dependencies-$SDP_BUILD_DEPENDENCY_VERSION.tar.gz | awk '{print $1}' > /root/prebuild/jenkins-dependencies-$SDP_BUILD_DEPENDENCY_VERSION.sha256
rm -rf /root/prebuild/dependencies
