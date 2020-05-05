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

# TBD Make this process automated
# Remove packages where later versions are available in ubi8 8.2 repos
rm /root/prebuild/dependencies/mono-complete/glib2-devel-2.56.4-7.el8.x86_64.rpm
rm /root/prebuild/dependencies/mono-complete/python3-pip-9.0.3-15.el8.noarch.rpm
rm /root/prebuild/dependencies/mono-complete/unzip-6.0-41.el8.x86_64.rpm
rm /root/prebuild/dependencies/mono-complete/libX11-1.6.7-1.el8.x86_64.rpm
rm /root/prebuild/dependencies/mono-complete/libX11-common-1.6.7-1.el8.noarch.rpm
rm /root/prebuild/dependencies/mono-complete/libtiff-4.0.9-15.el8.x86_64.rpm
rm /root/prebuild/dependencies/mono-complete/libxcb-1.13-5.el8.x86_64.rpm
rm /root/prebuild/dependencies/mono-complete/pixman-0.36.0-1.el8.x86_64.rpm
rm /root/prebuild/dependencies/mono-complete/python36-3.6.8-2.module_el8.1.0+245+c39af44f.x86_64.rpm


# fetch dependency-check upstream binary
curl -sSLo /root/prebuild/dependencies/owasp/dependency-check-${OWASP_DEP_CHK_VERSION}-release.zip https://dl.bintray.com/jeremy-long/owasp/dependency-check-${OWASP_DEP_CHK_VERSION}-release.zip 

yum install -y ruby 
# fetch ruby dependencies
gem install bundle-audit  -i /root/prebuild/dependencies/temp/bundle-audit --no-document --no-rdoc --no-ri && \
cp /root/prebuild/dependencies/temp/bundle-audit/cache/* /root/prebuild/dependencies/bundle-audit && \
gem install --force --local /root/prebuild/dependencies/bundle-audit/*.gem 
rm -rf /root/prebuild/dependencies/temp
