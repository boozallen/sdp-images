#!/bin/bash

set -xe

OWASP_DEP_CHK_VERSION=5.2.4
SDP_DCAR_OWASP_DEP_CHK_VERSION=dcar-0.2

rm -rf /root/prebuild/dependencies

mkdir -p /root/prebuild/dependencies/centos-release-scl /root/prebuild/dependencies/rh-ruby23 /root/prebuild/dependencies/rubygems-update /root/prebuild/dependencies/temp/rubygems-update /root/prebuild/dependencies/temp/bundle-audit /root/prebuild/dependencies/bundle-audit /root/prebuild/dependencies/owasp

curl -sSLo /root/prebuild/dependencies/owasp/dependency-check-${SDP_DCAR_OWASP_DEP_CHK_VERSION}-release.zip https://dl.bintray.com/jeremy-long/owasp/dependency-check-${OWASP_DEP_CHK_VERSION}-release.zip 

yumdownloader centos-release-scl --resolve --destdir /root/prebuild/dependencies/centos-release-scl
rpm -ivh --replacepkgs --replacefiles /root/prebuild/dependencies/centos-release-scl/*.rpm
yumdownloader rh-ruby23 --resolve --destdir /root/prebuild/dependencies/rh-ruby23
rpm -ivh --replacepkgs --replacefiles /root/prebuild/dependencies/rh-ruby23/*.rpm
printf '\
gem install "rubygems-update:<3.0.0"  -i /root/prebuild/dependencies/temp/rubygems-update --no-rdoc --no-ri && \
cp /root/prebuild/dependencies/temp/rubygems-update/cache/* /root/prebuild/dependencies/rubygems-update && \
gem install --force --local /root/prebuild/dependencies/rubygems-update/*.gem && \
update_rubygems && \
gem install bundle-audit  -i /root/prebuild/dependencies/temp/bundle-audit --no-rdoc --no-ri && \
cp /root/prebuild/dependencies/temp/bundle-audit/cache/* /root/prebuild/dependencies/bundle-audit && \
gem install --force --local /root/prebuild/dependencies/bundle-audit/*.gem && \
rm -rf /root/prebuild/dependencies/temp' | scl enable rh-ruby23 bash 




