#!/bin/bash

set -xe

SDP_DCAR_OWASP_DEP_CHK_VERSION=dcar-1.8

cd /root/prebuild
tar czvf owasp-dep-check-dependencies-$SDP_DCAR_OWASP_DEP_CHK_VERSION.tar.gz dependencies
gpg --import /root/prebuild/BAH-public.key
gpg --import --allow-secret-key-import  /root/prebuild/BAH-private.key
gpg --output /root/prebuild/owasp-dep-check-dependencies-$SDP_DCAR_OWASP_DEP_CHK_VERSION.sig --detach-sig /root/prebuild/owasp-dep-check-dependencies-$SDP_DCAR_OWASP_DEP_CHK_VERSION.tar.gz
sha256sum /root/prebuild/owasp-dep-check-dependencies-$SDP_DCAR_OWASP_DEP_CHK_VERSION.tar.gz | awk '{print $1}' > /root/prebuild/owasp-dep-check-dependencies-$SDP_DCAR_OWASP_DEP_CHK_VERSION.sha256
rm -rf /root/prebuild/dependencies
