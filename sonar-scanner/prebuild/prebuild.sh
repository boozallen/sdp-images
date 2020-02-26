#!/bin/bash

set -xe

BRANCH_VERSION=dcar-0.2
SONAR_SCANNER_VERSION=3.0.3.778

rm -rf /root/prebuild/dependencies
mkdir -p /root/prebuild/dependencies/sonar-scanner

file=sonar-scanner-${SONAR_SCANNER_VERSION}
curl --create-dirs -sSLo /root/prebuild/dependencies/sonar-scanner/${file} https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONAR_SCANNER_VERSION}-linux.zip

INSTALL_PKGS="java-1.8.0-openjdk-devel curl grep pgrep sed unzip which" && \
    yum --nogpgcheck --disablerepo unified_platform_ubi8_appstream --disablerepo unified_platform_ubi8_os --disableplugin=subscription-manager -y update-minimal --setopt=tsflags=nodocs \
        --security --sec-severity=Important --sec-severity=Critical && \
    yum --nogpgcheck --disablerepo unified_platform_ubi8_appstream --disablerepo unified_platform_ubi8_os --disableplugin=subscription-manager -y install --setopt=tsflags=nodocs ${INSTALL_PKGS}

cd /root/prebuild
tar czvf sonar-scanner-dependencies-$BRANCH_VERSION.tar.gz dependencies
gpg --import /root/prebuild/BAH-public.key
gpg --import --allow-secret-key-import  /root/prebuild/BAH-private.key
gpg --output /root/prebuild/sonar-scanner-dependencies-$BRANCH_VERSION.sig --detach-sig /root/prebuild/sonar-scanner-dependencies-$BRANCH_VERSION.tar.gz
sha256sum /root/prebuild/sonar-scanner-dependencies-$BRANCH_VERSION.tar.gz | awk '{print $1}' > /root/prebuild/sonar-scanner-dependencies-$BRANCH_VERSION.sha256
rm -rf /root/prebuild/dependencies
