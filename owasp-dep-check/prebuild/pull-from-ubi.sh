#!/bin/bash

set -xe

OWASP_DEP_CHK_VERSION=5.3.2
SDP_DCAR_OWASP_DEP_CHK_VERSION=dcar-1.1

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

dnf download glib2-devel  -y --resolve --destdir /root/prebuild/dependencies/mono-complete 
dnf download python3-pip  -y --resolve --destdir /root/prebuild/dependencies/mono-complete 
dnf download unzip  -y --resolve --destdir /root/prebuild/dependencies/mono-complete 
dnf download libX11 -y --resolve --destdir /root/prebuild/dependencies/mono-complete 
dnf download libX11-common -y --resolve --destdir /root/prebuild/dependencies/mono-complete 
dnf download libtiff -y --resolve --destdir /root/prebuild/dependencies/mono-complete 
dnf download libxcb -y --resolve --destdir /root/prebuild/dependencies/mono-complete 
dnf download pixman -y --resolve --destdir /root/prebuild/dependencies/mono-complete 
dnf download python36 -y --resolve --destdir /root/prebuild/dependencies/mono-complete 


