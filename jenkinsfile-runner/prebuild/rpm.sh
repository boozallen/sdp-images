#!/bin/bash

set -xe

mkdir -p /root/prebuild/dependencies/rpms

yum --assumeyes update
dnf --assumeyes install 'dnf-command(config-manager)'
yum --assumeyes install yum-utils

yumdownloader git --resolve --alldeps --destdir /root/prebuild/dependencies/rpms

rm -f /root/prebuild/dependencies/rpms/coreutils* \
      /root/prebuild/dependencies/rpms/gawk* \
      /root/prebuild/dependencies/rpms/os-pro* \
      /root/prebuild/dependencies/rpms/dbus* \
      /root/prebuild/dependencies/rpms/dracut* \
      /root/prebuild/dependencies/rpms/grub* \
      /root/prebuild/dependencies/rpms/ca-cert* \
      /root/prebuild/dependencies/rpms/device-mapper* \
      /root/prebuild/dependencies/rpms/systemd* 
