#!/bin/bash

set -xe

OWASP_DEP_CHK_VERSION=5.3.2
SDP_DCAR_OWASP_DEP_CHK_VERSION=dcar-1.1

rm -rf /root/prebuild/dependencies

# Create relevant directories

mkdir -p /root/prebuild/dependencies/mono-complete  /root/prebuild/dependencies/temp/bundle-audit /root/prebuild/dependencies/bundle-audit /root/prebuild/dependencies/owasp

# fetch mono-complete
su -c 'curl https://download.mono-project.com/repo/centos8-stable.repo | tee /etc/yum.repos.d/mono-centos8-stable.repo'

yum install -y yum-utils
yumdownloader mono-complete -y --resolve --destdir /root/prebuild/dependencies/mono-complete --disableplugin=subscription-manager


# fetch dependency-check upstream binary
curl -sSLo /root/prebuild/dependencies/owasp/dependency-check-${OWASP_DEP_CHK_VERSION}-release.zip https://dl.bintray.com/jeremy-long/owasp/dependency-check-${OWASP_DEP_CHK_VERSION}-release.zip 

yum install -y ruby 
# fetch ruby dependencies
gem install bundle-audit  -i /root/prebuild/dependencies/temp/bundle-audit --no-document --no-rdoc --no-ri && \
cp /root/prebuild/dependencies/temp/bundle-audit/cache/* /root/prebuild/dependencies/bundle-audit && \
gem install --force --local /root/prebuild/dependencies/bundle-audit/*.gem 
rm -rf /root/prebuild/dependencies/temp
