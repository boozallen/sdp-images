# Copyright © 2018 Booz Allen Hamilton. All Rights Reserved.
# This software package is licensed under the Booz Allen Public License. The license can be found in the License file or at http://boozallen.github.io/licenses/bapl
FROM registry.access.redhat.com/ubi7/ubi:7.7-310
MAINTAINER terrana_steven@bah.com

### Required Atomic/OpenShift Labels - https://github.com/projectatomic/ContainerApplicationGenericLabels
LABEL name="Solutions Delivery Platform: Helm" \
      maintainer="terrana_steven@bah.com" \
      vendor="Booz Allen Hamilton" \
      version="1.0" \
      release="1.0" \
      summary="A container used by the openshift and kubernetes libraries within the Solutions Delivery Platform" \
      description="A container used by the openshift and kubernetes libraries within the Solutions Delivery Platform"

ARG user=sdp
ARG group=sdp
ARG uid=1000
ARG gid=1000
ARG SDP_HOME=/home/sdp_home
RUN mkdir -p $SDP_HOME \
  && chown ${uid}:${gid} $SDP_HOME \
  && groupadd -g ${gid} ${group} \
  && useradd -d "$SDP_HOME" -u ${uid} -g ${gid} -m -s /bin/bash ${user}


ARG TARBALL=helm-dependencies-dcar-0.4.tar.gz
RUN mkdir /root/tmp && curl -sSLo /root/tmp/helm-dependencies-dcar-0.4.tar.gz https://github.com/boozallen/sdp-images/releases/download/dcar-0.4/helm-dependencies-dcar-0.4.tar.gz

###Unpack tarball containing dependencies && place files into needed locations
RUN cd /root/tmp && tar -zxf ./${TARBALL} && rm -fv ./${TARBALL} && \
    mv dependencies/openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit/oc /usr/local/bin/oc && \
    mv dependencies/linux-amd64/helm /usr/local/bin/helm && \
    mv dependencies/kubectl /usr/local/bin/kubectl && \
    chmod +x /usr/local/bin/oc && \
    chmod +x /usr/local/bin/helm && \
    chmod +x /usr/local/bin/kubectl && \
    cd - && rm -rf /root/tmp

USER ${user}
