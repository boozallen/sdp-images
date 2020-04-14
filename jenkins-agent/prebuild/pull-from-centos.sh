#!/bin/bash

set -xe

yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum-config-manager --enable docker-ce-edge
yumdownloader docker-ce-19.03.5-3.el7 --resolve --destdir /root/prebuild/dependencies/docker-ce


