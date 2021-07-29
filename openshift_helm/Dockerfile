# Copyright © 2018 Booz Allen Hamilton. All Rights Reserved.
# This software package is licensed under the Booz Allen Public License. The license can be found in the License file or at http://boozallen.github.io/licenses/bapl
ARG BASE_REGISTRY=registry.access.redhat.com
ARG BASE_IMAGE=ubi8/ubi
ARG BASE_TAG=8.4
FROM ${BASE_REGISTRY}/${BASE_IMAGE}:${BASE_TAG}
MAINTAINER terrana_steven@bah.com

### Required Atomic/OpenShift Labels - https://github.com/projectatomic/ContainerApplicationGenericLabels
LABEL name="Solutions Delivery Platform: Helm" \
      maintainer="terrana_steven@bah.com" \
      vendor="Booz Allen Hamilton" \
      version="1.0" \
      release="1.0" \
      summary="A container used by the openshift and kubernetes libraries within the Solutions Delivery Platform" \
      description="A container used by the openshift and kubernetes libraries within the Solutions Delivery Platform"

ARG SDP_BUILD_DEPENDENCY_VERSION=dcar-2.1
ARG user=sdp
ARG group=sdp
ARG uid=1000
ARG gid=1000
ARG SDP_HOME=/home/sdp_home
RUN mkdir -p $SDP_HOME \
  && chown ${uid}:${gid} $SDP_HOME \
  && groupadd -g ${gid} ${group} \
  && useradd -d "$SDP_HOME" -u ${uid} -g ${gid} -m -s /bin/bash ${user}

### Download dependency tarball and authenticate
ARG TARBALL=helm-dependencies-${SDP_BUILD_DEPENDENCY_VERSION}
RUN mkdir /root/tmp
RUN curl -sSLo /root/tmp/${TARBALL}.tar.gz https://github.com/boozallen/sdp-images/releases/download/${SDP_BUILD_DEPENDENCY_VERSION}/${TARBALL}.tar.gz
#COPY prebuild/${TARBALL}.tar.gz root/tmp/${TARBALL}.tar.gz
COPY prebuild/BAH-public.key /root/tmp/.
COPY prebuild/${TARBALL}.sig /root/tmp/.
COPY prebuild/${TARBALL}.sha256 /root/tmp/.
RUN cd /root/tmp/ && gpg --import BAH-public.key
RUN cd /root/tmp/ && gpg --verify ${TARBALL}.sig ${TARBALL}.tar.gz
RUN cd /root/tmp/ && echo "$(cat ${TARBALL}.sha256) ${TARBALL}.tar.gz" | sha256sum --check --status

###Unpack tarball containing dependencies && place files into needed locations
RUN cd /root/tmp && tar -zxf ./${TARBALL}.tar.gz && rm -fv ./${TARBALL}.tar.gz && \
    mv dependencies/openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit/oc /usr/local/bin/oc && \
    mv dependencies/linux-amd64/helm /usr/local/bin/helm && \
    mv dependencies/kubectl /usr/local/bin/kubectl && \
    chmod +x /usr/local/bin/oc && \
    chmod +x /usr/local/bin/helm && \
    chmod +x /usr/local/bin/kubectl && \
    cd - && rm -rf /root/tmp/*

USER ${user}
