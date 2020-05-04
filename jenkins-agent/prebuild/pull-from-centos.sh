#!/bin/bash

set -xe
yum --assumeyes update
dnf --assumeyes install 'dnf-command(config-manager)'
yum --assumeyes install yum-utils
dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yumdownloader docker-ce-19.03.5-3.el7 --resolve --alldeps --destdir /root/prebuild/dependencies/docker-ce
yumdownloader docker-ce-cli --resolve --destdir /root/prebuild/dependencies/docker-ce
yumdownloader https://download.docker.com/linux/centos/7/x86_64/stable/Packages/containerd.io-1.2.6-3.3.el7.x86_64.rpm --resolve --destdir /root/prebuild/dependencies/docker-ce
yumdownloader audit-libs-3.0-0.13.20190507gitf58ec40.el8 --resolve --destdir /root/prebuild/dependencies/docker-ce
yumdownloader rpm-libs-4.14.2-26.el8_1 --resolve --destdir /root/prebuild/dependencies/docker-ce
yumdownloader libselinux-2.9-2.1.el8 --resolve --destdir /root/prebuild/dependencies/docker-ce
yumdownloader libsemanage-2.9-1.el8 --resolve --destdir /root/prebuild/dependencies/docker-ce
yumdownloader rpm-4.14.2-26.el8_1 --resolve --destdir /root/prebuild/dependencies/docker-ce
