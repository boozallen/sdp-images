#!/bin/bash

set -xe

SONAR_SCANNER_VERSION=3.0.3.778

rm -rf /root/prebuild/dependencies
mkdir -p /root/prebuild/dependencies/sonar-scanner

file=sonar-scanner-${SONAR_SCANNER_VERSION}-linux.zip
curl --create-dirs -sSLo /root/prebuild/dependencies/sonar-scanner/${file} https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONAR_SCANNER_VERSION}-linux.zip

INSTALL_PKGS="java-1.8.0-openjdk-devel curl grep pgrep sed unzip which" && \
    yum --nogpgcheck --disablerepo unified_platform_ubi8_appstream --disablerepo unified_platform_ubi8_os --disableplugin=subscription-manager -y update-minimal --setopt=tsflags=nodocs \
        --security --sec-severity=Important --sec-severity=Critical && \
    yum --nogpgcheck --disablerepo unified_platform_ubi8_appstream --disablerepo unified_platform_ubi8_os --disableplugin=subscription-manager -y install --setopt=tsflags=nodocs ${INSTALL_PKGS}
