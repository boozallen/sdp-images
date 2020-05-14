#!/bin/bash

set -xe

OC_VERSION=v3.11.0
HELM_VERSION=v3.2.1
KUBECTL_VERSION=v1.18.0

rm -rf /root/prebuild/dependencies
mkdir -p /root/prebuild/dependencies
cd /root/prebuild/dependencies

file1=openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit
file2=linux-amd64
file3=kubectl

#oc ${file1}
curl -kLo /root/prebuild/dependencies/${file1}.tar.gz https://github.com/openshift/origin/releases/download/${OC_VERSION}/${file1}.tar.gz
tar -zxf ${file1}.tar.gz
rm -rf ${file1}.tar.gz

#helm ${file2}
curl -ko /root/prebuild/dependencies/${file2}.tar.gz https://get.helm.sh/helm-${HELM_VERSION}-${file2}.tar.gz
tar -zxf ${file2}.tar.gz
rm -rf ${file2}.tar.gz

#kubectl ${file3}
curl -ko /root/prebuild/dependencies/${file3} https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl

SDP_BUILD_DEPENDENCY_VERSION=dcar-1.1

cd /root/prebuild
tar czvf helm-dependencies-$SDP_BUILD_DEPENDENCY_VERSION.tar.gz dependencies
gpg --import /root/prebuild/BAH-public.key
gpg --import --allow-secret-key-import  /root/prebuild/BAH-private.key
gpg --output /root/prebuild/helm-dependencies-$SDP_BUILD_DEPENDENCY_VERSION.sig --detach-sig /root/prebuild/helm-dependencies-$SDP_BUILD_DEPENDENCY_VERSION.tar.gz
sha256sum /root/prebuild/helm-dependencies-$SDP_BUILD_DEPENDENCY_VERSION.tar.gz | awk '{print $1}' > /root/prebuild/helm-dependencies-$SDP_BUILD_DEPENDENCY_VERSION.sha256
rm -rf /root/prebuild/dependencies
