#!/bin/bash

set -xe

OWASP_DEP_CHK_VERSION=5.3.1
SDP_DCAR_OWASP_DEP_CHK_VERSION=dcar-0.7

rm -rf /root/prebuild/dependencies

# Create relevant directories

mkdir -p /root/prebuild/dependencies/mono-devel /root/prebuild/dependencies/centos-release-scl /root/prebuild/dependencies/rh-ruby23 /root/prebuild/dependencies/rubygems-update /root/prebuild/dependencies/temp/rubygems-update /root/prebuild/dependencies/temp/bundle-audit /root/prebuild/dependencies/bundle-audit /root/prebuild/dependencies/owasp

# fetch mono-devel
echo -e "[centos] \nname=CentOS-7\nbaseurl=http://mirror.vcu.edu/pub/gnu_linux/centos/7/os/x86_64/\nenabled=1\ngpgcheck=1\ngpgkey=http://mirror.vcu.edu/pub/gnu_linux/centos/7/os/x86_64/RPM-GPG-KEY-CentOS-7" > /etc/yum.repos.d/centos.repo

su -c 'curl https://download.mono-project.com/repo/centos7-stable.repo | tee /etc/yum.repos.d/mono-centos7-stable.repo'


yumdownloader mono-devel -y --resolve --destdir /root/prebuild/dependencies/mono-devel --disableplugin=subscription-manager

# fetch dependency-check upstream binary
curl -sSLo /root/prebuild/dependencies/owasp/dependency-check-${OWASP_DEP_CHK_VERSION}-release.zip https://dl.bintray.com/jeremy-long/owasp/dependency-check-${OWASP_DEP_CHK_VERSION}-release.zip 


# fetch ruby dependencies
yumdownloader centos-release-scl --resolve --destdir /root/prebuild/dependencies/centos-release-scl
rpm -ivh --replacepkgs --replacefiles /root/prebuild/dependencies/centos-release-scl/*.rpm
yumdownloader rh-ruby23 --resolve --destdir /root/prebuild/dependencies/rh-ruby23
rpm -ivh --replacepkgs --replacefiles /root/prebuild/dependencies/rh-ruby23/*.rpm
printf '\
gem install "rubygems-update:<3.0.0"  -i /root/prebuild/dependencies/temp/rubygems-update --no-document --no-rdoc --no-ri && \
cp /root/prebuild/dependencies/temp/rubygems-update/cache/* /root/prebuild/dependencies/rubygems-update && \
gem install --force --local /root/prebuild/dependencies/rubygems-update/*.gem && \
update_rubygems && \
gem install bundle-audit  -i /root/prebuild/dependencies/temp/bundle-audit --no-document --no-rdoc --no-ri && \
cp /root/prebuild/dependencies/temp/bundle-audit/cache/* /root/prebuild/dependencies/bundle-audit && \
gem install --force --local /root/prebuild/dependencies/bundle-audit/*.gem && \
rm -rf /root/prebuild/dependencies/temp' | scl enable rh-ruby23 bash 

