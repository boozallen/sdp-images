#!/bin/bash

set -xe

BRANCH_VERSION=dcar-0.2

cd /root/prebuild
tar czvf sonar-scanner-dependencies-$BRANCH_VERSION.tar.gz dependencies
gpg --import /root/prebuild/BAH-public.key
gpg --import --allow-secret-key-import  /root/prebuild/BAH-private.key
gpg --output /root/prebuild/sonar-scanner-dependencies-$BRANCH_VERSION.sig --detach-sig /root/prebuild/sonar-scanner-dependencies-$BRANCH_VERSION.tar.gz
sha256sum /root/prebuild/sonar-scanner-dependencies-$BRANCH_VERSION.tar.gz | awk '{print $1}' > /root/prebuild/sonar-scanner-dependencies-$BRANCH_VERSION.sha256
rm -rf /root/prebuild/dependencies
